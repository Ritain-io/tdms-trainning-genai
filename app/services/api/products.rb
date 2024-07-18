# frozen_string_literal: true

module Api
	module Products
		TABLE = 'Product'
		
		def self.get_all_products(controller_name, params, user)
			products_filtered = Product.all

			products = if params.keys.count == 1
									 products_filtered.where(params)
				         else
					         Product.where(Utils::filter_params(controller_name, params))
			           end
			{
				headers: Table::Headers.get_headers(self),
				data:    Masking::ObfProcess.list_data(params.dig('environment_id'), products, TABLE, user)
			}
		end
		
		def self.show_product(product, user)
			Masking::ObfProcess.show_data(product, TABLE, user)
		end

		def self.basic_info(env)
			products = if env.nil?
									 Product.all
								 else
									 Product.where(environment_id: env)
								 end
			products.map { |product| { id: product.id, name: product.name } }
		end
		
		def self.create_product(params)
			data                     	= {}
			data[:name] 							= params.try(:[], :name)
			data[:product_type]       = params.try(:[], :product_type)
			data[:code]           	  = params.try(:[], :code)
			data[:sku]        				= params.try(:[], :sku)
			data[:environment_id]     = params.try(:[], :environment_id)

			product = Product.create!(data)
			Masking::ObfProcess.new_data(product, TABLE)
		end
		
		def self.update_product(product, params)
			data                      = {}
			data[:name] 							= params.try(:[], :name) if params.try(:[], :name)
			data[:product_type]       = params.try(:[], :product_type) if params.try(:[], :product_type)
			data[:code]        				= params.try(:[], :code) if params.try(:[], :code)
			data[:sku]        				= params.try(:[], :sku) if params.try(:[], :sku)
			data[:environment_id]     = params.try(:[], :environment_id) if params.try(:[], :environment_id)

			product.update(data)
			Masking::ObfProcess.update_data(params, TABLE)
		end
		
		def self.destroy_product(product)
			product.destroy
			Masking::ObfProcess.delete_data(product, TABLE)
		end
		
		def self.get_graph(params, user)
			column         = params.try(:[], :column).present? ? params.try(:[], :column) : 'sku'
			environment_id = params.try(:[], :environment_id)
			
			records = Product.where(environment_id: environment_id)
			
			grouped_records = records.group_by { |record| record.send(column) }
			
			product_types = records.pluck(:product_type).uniq.map { |product_type| product_type.blank? ? 'unavailable' : product_type.downcase }.uniq
			
			data = grouped_records.map do |gr|
				filtered_records = gr.last
				key              = gr.first
				counts           = product_types.map do |product_type|
					if product_type == 'unavailable'
						filtered_records.select { |y| y.product_type.blank? }.count
					else
						filtered_records.select { |y| y.product_type&.downcase == product_type }.count
					end
				end
				{ key&.to_sym => counts }
			end
			
			Masking::ObfProcess.graphs({ data: data, labels: product_types }, environment_id, TABLE, user)
			
		end
		
		def self.import(params)
			product_counter = { added: 0, skipped: 0, errors: [] }
			
			data = SmarterCSV.process(params.try(:[], :file).tempfile, { col_sep: ';' })
			data.each_with_index do |d, i|
				if d.try(:[], :environment_id).blank?
					product_counter[:skipped] += 1
					product_counter[:errors] << "Missing value for column environment_id in line #{i + 1}"
					next
				elsif d.try(:[], :name).blank?
					product_counter[:skipped] += 1
					product_counter[:errors] << "Missing value for column name in line #{i + 1}"
					next
				elsif d.try(:[], :product_type).blank?
					product_counter[:skipped] += 1
					product_counter[:errors] << "Missing value for column product_type in line #{i + 1}"
					next
				end
				
				product = Product.find_by(name: d.try(:[], :name), environment_id: d.try(:[], :environment_id),
				                          sku:  d.try(:[], :sku))
				
				if product.present?
					product.update!(name:         d.try(:[], :name), environment_id: d.try(:[], :environment_id),
					                product_type: d.try(:[], :product_type), code: d.try(:[], :code), sku: d.try(:[], :sku))
					Masking::ObfProcess.new_data(product, TABLE)
				else
					new_product = Product.create!(name:         d.try(:[], :name), environment_id: d.try(:[], :environment_id),
					                product_type: d.try(:[], :product_type), code: d.try(:[], :code), sku: d.try(:[], :sku))
					Masking::ObfProcess.new_data(new_product, TABLE)
				end
				
				product_counter[:added] += 1
			end
			product_counter
		end
	end
end
