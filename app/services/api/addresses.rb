# frozen_string_literal: true
require 'smarter_csv'

module Api
	module Addresses
		def self.get_all_addresses(controller_name, params)
			# addresses_filtered = Address.where(environment_id: params.try(:[], :environment_id))
			addresses_filtered = Address.all
			
			# addresses = if params.keys.count == 1
			# 	            addresses_filtered
			# 	          else
			# 		          addresses_filtered.where(Utils::filter_params(controller_name, params))
			#             end
			
			addresses = addresses_filtered.where(Utils::filter_params(controller_name, params))
			{
				headers: Table::Headers.get_headers(self),
				data:    addresses.order(id: :desc).map { |product| AddressSerializer.new(product).as_json }
			}
		end
		
		def self.create_address(params)
			data                    = {}
			data[:country]          = params.try(:[], :country)
			data[:state]            = params.try(:[], :state)
			data[:city]             = params.try(:[], :city)
			data[:neighbh]          = params.try(:[], :neighbh)
			data[:st_name]          = params.try(:[], :st_name)
			data[:st_number]        = params.try(:[], :st_number)
			data[:floor_number]     = params.try(:[], :floor_number)
			data[:apartment_number] = params.try(:[], :apartment_number)
			data[:zip_code]         = params.try(:[], :zip_code)
			data[:lat]              = params.try(:[], :lat)
			data[:lng]              = params.try(:[], :lng)
			data[:environment_id]   = params.try(:[], :environment_id)
			
			Address.create!(data)
		end
		
		def self.update_address(address, params)
			data                    = {}
			data[:country]          = params.try(:[], :country) if params.try(:[], :country)
			data[:state]            = params.try(:[], :state) if params.try(:[], :state)
			data[:city]             = params.try(:[], :city) if params.try(:[], :city)
			data[:neighbh]          = params.try(:[], :neighbh) if params.try(:[], :neighbh)
			data[:st_name]          = params.try(:[], :st_name) if params.try(:[], :st_name)
			data[:st_number]        = params.try(:[], :st_number) if params.try(:[], :st_number)
			data[:floor_number]     = params.try(:[], :floor_number) if params.try(:[], :floor_number)
			data[:apartment_number] = params.try(:[], :apartment_number) if params.try(:[], :apartment_number)
			data[:zip_code]         = params.try(:[], :zip_code) if params.try(:[], :zip_code)
			data[:lat]              = params.try(:[], :lat) if params.try(:[], :lat)
			data[:lng]              = params.try(:[], :lng) if params.try(:[], :lng)
			data[:environment_id]   = params.try(:[], :environment_id) if params.try(:[], :environment_id)
			
			address.update(data)
		end
		
		def self.basic_info(env)
			addresses = if env.nil?
				            Address.all
				          else
					          Address.where(environment_id: env)
			            end
			addresses.map { |address| { id: address.id, name: "#{address&.country}, #{address&.state}, #{address&.city}" } }
		end
		
		def self.get_graph(params)
			column            = params.try(:[], :column).present? ? params.try(:[], :column) : 'country'
			#environment_id    = params.try(:[], :environment_id)
			is_column_boolean = Address.columns_hash[column].type == :boolean
			
			#records = Address.where(environment_id: environment_id)
			records = Address.all
			
			grouped_records = records.group_by { |record| record.send(column) }

			countries = records.pluck(:country).uniq.map { |country| country.blank? ? 'unavailable' : country.downcase }.uniq

			data = grouped_records.map do |gr|
				filtered_records = gr.last
				key              = gr.first
				key              = Utils::get_boolean_value(column, key) if is_column_boolean
				# available        = filtered_records.select { |y| y.reserved == false }.count
				# reserved         = filtered_records.select { |y| y.reserved == true }.count
				# unavailable      = filtered_records.select { |y| y.reserved == nil }.count
				#{ key&.to_sym => [available, reserved, unavailable] }
				counts           = countries.map do |country|
					if country == 'unavailable'
						filtered_records.select { |y| y.country.blank? }.count
					else
						filtered_records.select { |y| y.country&.downcase == country }.count
					end
				end
				{ key&.to_sym => counts }
			end
			
			#{ data: data, labels: %w[available reserved unavailable] }
			{ data: data, labels: countries }
		end
		
		def self.import(params)
			address_counter = { added: 0, skipped: 0, errors: [] }
			
			data = SmarterCSV.process(params.try(:[], :file).tempfile, { col_sep: ';' })
			data.each_with_index do |d, i|
				address = Address.where(country:          d.try(:[], :country), state: d.try(:[], :state),
				                        city:             d.try(:[], :city), neighbh: d.try(:[], :neighbh),
				                        environment_id:   params.try(:[], :environment_id), st_name: d.try(:[], :st_name),
				                        st_number:        d.try(:[], :st_number), floor_number: d.try(:[], :floor_number),
				                        apartment_number: d.try(:[], :apartment_number), zip_code: d.try(:[], :zip_code))
				
				if address.present?
					address.update!(country:          d.try(:[], :country), state: d.try(:[], :state),
					                city:             d.try(:[], :city), neighbh: d.try(:[], :neighbh),
					                environment_id:   params.try(:[], :environment_id), st_name: d.try(:[], :st_name),
					                st_number:        d.try(:[], :st_number), floor_number: d.try(:[], :floor_number),
					                apartment_number: d.try(:[], :apartment_number), zip_code: d.try(:[], :zip_code),
					                lat:              d.try(:[], :lat), lng: d.try(:[], :lng))
				else
					Address.create!(country:          d.try(:[], :country), state: d.try(:[], :state),
					                city:             d.try(:[], :city), neighbh: d.try(:[], :neighbh),
					                environment_id:   params.try(:[], :environment_id), st_name: d.try(:[], :st_name),
					                st_number:        d.try(:[], :st_number), floor_number: d.try(:[], :floor_number),
					                apartment_number: d.try(:[], :apartment_number), zip_code: d.try(:[], :zip_code),
					                lat:              d.try(:[], :lat), lng: d.try(:[], :lng))
				end
				
				address_counter[:added] += 1
			end
			address_counter
		end
		
		## Exception Handling
		class InvalidCSV < StandardError
		end
	end
end
