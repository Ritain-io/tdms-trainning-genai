# frozen_string_literal: true

module Api
	module Customers
		TABLE = 'Customer'
		
		def self.get_all_customers(controller_name, params, user)
			customers_filtered = Customer.all
			
			customers = if params.keys.count == 1
				            customers_filtered.where(params)
				          else
					          customers = filter_booleans(customers_filtered, params)
					          customers.where(Utils::filter_params(controller_name, params))
			            end
			{
				headers: Table::Headers.get_headers(self),
				data:    Masking::ObfProcess.list_data(params.dig('environment_id'), customers, TABLE, user)
			}
		end
		
		def self.show_customer(customer, user)
			basic_info = Masking::ObfProcess.show_data(customer, TABLE, user)
			
			services = Service.where(customer_id: customer.id).map do |service|
				ServiceSerializer.new(service).as_json
				Masking::ObfProcess.show_data(service, 'Service', user)
			end
			
			basic_info[:tables] = [services: { headers: Table::Headers.get_headers('Service'), data: services, modal_relations: get_relations('Service') },]
			basic_info
		end
		
		def self.basic_info(env)
			customers = if env.nil?
				            Customer.all
				          else
					          Customer.where(environment_id: env)
			            end
			
			customers.map { |customer| { id: customer.id, name: customer.full_name } }
		end
		
		def self.create_customer(params)
			data                      = {}
			data[:full_name] 					= params.try(:[], :full_name)
			data[:document_type] 			= params.try(:[], :document_type)
			data[:document_value] 		= params.try(:[], :document_value)
			data[:customer_type] 			= params.try(:[], :customer_type)
			data[:environment_id] 		= params.try(:[], :environment_id)

			if params.try(:[], :state).present?
				data[:state] = (params.try(:[], :state) == '-') ? nil : params.try(:[], :state)
			end

			customer = Customer.create!(data)
			Masking::ObfProcess.new_data(customer, TABLE)
		end
		
		def self.update_customer(customer, params)
			data                      = {}
			data[:full_name] 					= params.try(:[], :full_name) if params.try(:[], :full_name)
			data[:document_type]      = params.try(:[], :document_type) if params.try(:[], :document_type)
			data[:document_value]     = params.try(:[], :document_value) if params.try(:[], :document_value)
			data[:customer_type] 			= params.try(:[], :customer_type) if params.try(:[], :customer_type)
			data[:environment_id]     = params.try(:[], :environment_id) if params.try(:[], :environment_id)

			if params.try(:[], :state).present?
				data[:state] = (params.try(:[], :state) == '-') ? nil : params.try(:[], :state)
			end

			customer.update(data)
			Masking::ObfProcess.update_data(params, TABLE)
		end
		
		def self.import(params)
			customers_counter = { added: 0, skipped: 0, errors: [] }
			
			data = SmarterCSV.process(params.try(:[], :file).tempfile, { col_sep: ';' })
			data.each_with_index do |d, i|
				# validate empty field
				
				if d.try(:[], :full_name).blank?
					customers_counter[:skipped] += 1
					customers_counter[:errors] << "Missing value for column full_name in line #{i + 1}"
					next
				elsif d.try(:[], :environment_id).blank?
					customers_counter[:skipped] += 1
					customers_counter[:errors] << "Missing value for column environment_id in line #{i + 1}"
					next
				elsif d.try(:[], :document_type).blank?
					customers_counter[:skipped] += 1
					customers_counter[:errors] << "Missing value for column document_type in line #{i + 1}"
					next
				elsif d.try(:[], :document_value).blank?
					customers_counter[:skipped] += 1
					customers_counter[:errors] << "Missing value for column document_value in line #{i + 1}"
					next
				elsif d.try(:[], :state).blank?
					customers_counter[:skipped] += 1
					customers_counter[:errors] << "Missing value for column state in line #{i + 1}"
					next
				elsif d.try(:[], :customer_type).blank?
					customers_counter[:skipped] += 1
					customers_counter[:errors] << "Missing value for column customer_type in line #{i + 1}"
					next
				end
				
				customer = Customer.find_by(environment_id: d.try(:[], :environment_id), document_type: d.try(:[], :document_type),
				                            document_value: d.try(:[], :document_value))
				
				if customer.present?
					customer.update!(full_name:      d.try(:[], :full_name), customer_type: d.try(:[], :customer_type),
					                 environment_id: d.try(:[], :environment_id), state: d.try(:[], :state))
					Masking::ObfProcess.update_data(customer, TABLE)
				else
					new_customer = Customer.create!(full_name:      d.try(:[], :full_name), customer_type: d.try(:[], :customer_type),
					                                environment_id: d.try(:[], :environment_id), document_type: d.try(:[], :document_type),
					                                document_value: d.try(:[], :document_value), state: d.try(:[], :state))
					Masking::ObfProcess.new_data(new_customer, TABLE)
				end
				
				customers_counter[:added] += 1
			end
			customers_counter
		end
		
		def self.get_graph(params, user)
			column         = params.try(:[], :column).present? ? params.try(:[], :column) : 'customer_type'
			environment_id = params.try(:[], :environment_id)
			
			records = Customer.where(environment_id: environment_id)
			
			grouped_records = records.group_by { |record| record.send(column) }
			
			customer_types = records.pluck(:customer_type).uniq.map { |customer_type| customer_type.blank? ? 'unavailable' : customer_type.downcase }.uniq
			
			data = grouped_records.map do |gr|
				filtered_records = gr.last
				key              = gr.first
				counts           = customer_types.map do |customer_type|
					if customer_type == 'unavailable'
						filtered_records.select { |y| y.customer_type.blank? }.count
					else
						filtered_records.select { |y| y.customer_type&.downcase == customer_type }.count
					end
				end
				{ key&.to_sym => counts }
			end
			Masking::ObfProcess.graphs({ data: data, labels: customer_types }, environment_id, TABLE, user)
		end
		
		private
		
		def self.get_relations(controller_name)
			keys    = controller_name.singularize.titleize.remove(' ').constantize._reflections.keys
			columns = controller_name.singularize.titleize.remove(' ').constantize.column_names
			
			keys.map do |key|
				next if key == 'environment'
				{ api_name: key.pluralize, modal_name: key } if columns.include? "#{key}_id"
			end.compact
		end
		
		def self.filter_booleans(customers_filtered, params)
			if params.try(:[], :state)
				states = params.try(:[], :state).split('|')
				return customers_filtered.where(state: states) if params.try(:[], :state)
			end
			customers_filtered
		end
	end
end
