# frozen_string_literal: true
require 'securerandom'
if Rails.env.development?
	
	def insert_environment_ids
		YAML.load_file(Rails.root.join('db', 'seeds', 'environments.yml')).each do |env|
			Environment.create! env if Environment.where(name: env['name']).empty?
		end
	end
	
	def insert_users
		YAML.load_file(Rails.root.join('db', 'seeds', 'users.yml')).each do |users|
			User.create! users if User.where(email: users['email']).empty?
		end
	end
	
	def insert_roles
		YAML.load_file(Rails.root.join('db', 'seeds', 'roles.yml')).each do |role|
			Role.create! role if Role.where(name: role['role']).empty?
		end
	end
	
	def insert_admin_users
		YAML.load_file(Rails.root.join('db', 'seeds', 'admin_users.yml')).each do |admin_user|
			AdminUser.create! admin_user if AdminUser.where(email: admin_user['email']).empty?
		end
	end
	
	def insert_customers
		YAML.load_file(Rails.root.join('db', 'seeds', 'customers.yml')).each do |customer|
			insert_single_customer(customer)
		end
	end
	
	def insert_single_customer(customer)
		customer_obj = Customer.create! customer if Customer.where(document_value: customer[:document_value], document_type: customer[:document_type]).empty?
		return if customer_obj.blank?
		version     = customer_obj.versions.first
		date        = customer[:created_at].strftime("%d%m%Y")
		env					= customer[:environment_id]
		version.update(timestamp: date, environment_id: env)
	end
	
	def insert_services
		YAML.load_file(Rails.root.join('db', 'seeds', 'services.yml')).each do |service|
			insert_single_service(service)
		end
	end
	
	def insert_single_service(service)
		service_obj = Service.create! service if Service.where(service_identifier: service[:service_identifier], customer_id: service[:customer_id]).empty?
		return if service_obj.blank?
		version     = service_obj.versions.first
		date        = service[:created_at].strftime("%d%m%Y")
		env					= service[:environment_id]
		version.update(timestamp: date, environment_id: env)
	end
	
	def insert_permissions
		YAML.load_file(Rails.root.join('db', 'seeds', 'permissions.yml')).each do |permission|
			Permission.create! permission if Permission.where(name: permission['name']).empty?
		end
	end
	
	def insert_role_permission
		YAML.load_file(Rails.root.join('db', 'seeds', 'role_permissions.yml')).each do |role_permission|
			RolePermission.create! role_permission if RolePermission.where(permission_id: role_permission['permission_id'],
			                                                               role_id:       role_permission['role_id']).empty?
		end
	end
	
	def insert_users_role
		YAML.load_file(Rails.root.join('db', 'seeds', 'user_roles.yml')).each do |user_role|
			UserRole.create! user_role if UserRole.where(user_id:        user_role['user_id'],
			                                             role_id:        user_role['role_id'],
			                                             environment_id: user_role['environment_id']).empty?
		end
	end
	
	def insert_products
		YAML.load_file(Rails.root.join('db', 'seeds', 'products.yml')).each do |product|
			insert_single_product(product)
		end
	end
	
	def insert_single_product(product)
		product_obj = Product.create! product if Product.where(name: product[:name]).empty?
		return if product_obj.blank?
		version     = product_obj.versions.first
		date        = product[:created_at].strftime("%d%m%Y")
		env					= product[:environment_id]
		version.update(timestamp: date, environment_id: env)
	end
	
	def insert_single_address(address)
		address_obj = Address.create! address
		return if address_obj.blank?
		version     = address_obj.versions.first
		date        = address[:created_at].strftime("%d%m%Y")
		env					= address[:environment_id]
		version.update(timestamp: date, environment_id: env)
	end
	
	### Call Operation for Insert Values in DB
	
	insert_users
	insert_roles
	insert_environment_ids
	insert_admin_users
	insert_permissions
	insert_users_role
	# insert_products
	# insert_customers
	# insert_services
	insert_role_permission
	
	DATE                     					= []
	ENVIRONMENT              					= Environment.all.pluck(:id)
	PRODUCT_PRODUCT_TYPE     					= ["equipment", "accessory"]
	CUSTOMER_CUSTOMER_TYPE   					= ["B2B", "B2C"]
	CUSTOMER_DOCUMENT_TYPE   					= ['Dni', 'Passport', 'CC']
	CUSTOMER_DOCUMENT_VALUE_PASSPORT	= ['AB123456', 'CD789012', 'EF345678', 'GH901234', 'IJ567890']
	CUSTOMER_DOCUMENT_VALUE_CC  			= ['123456789AB', '987654321CD', '456789012EF', '901234567GH', '345678901IJ']
	CUSTOMER_DOCUMENT_VALUE_DNI  			= ['12345678A', '87654321B', '34567890C', '90123456D', '56789012E']
	SERVICE_NOTES            					= ["Notes 1", "Notes 2", "Notes 3"]
	SERVICE_STATE            					= ["State 1", "State 2", "State 3"]
	SERVICE_RESERVED         					= [true, false]
	ADDRESS_COUNTRY          					= ["Country 1", "Country 2", "Country 3", "Country 4", "Country 5", "Country 6"]
	ADDRESS_STATE            					= ["State 1", "State 2", "State 3", "State 4", "State 5", "State 6"]
	ADDRESS_CITY             					= ["City 1", "City 2", "City 3", "City 4", "City 5", "City 6"]
	ADDRESS_NEIGHBH          					= ["Neighbh 1", "Neighbh 2", "Neighbh 3", "Neighbh 4", "Neighbh 5", "Neighbh 6"]
	ADDRESS_ST_NAME          					= ["St name 1", "St name 2", "St name 3", "St name 4", "St name 5", "St name 6"]
	ADDRESS_ST_NUMBER        					= ["St number 1", "City number 2", "City number 3", "City number 4", "City number 5", "City number 6"]
	ADDRESS_FLOOR_NUMBER     					= ["Floor 1", "Floor 2", "Floor 3", "Floor 4", "Floor 5", "Floor 6"]
	ADDRESS_APARTMENT_NUMBER 					= ["Apartment 1", "Apartment 2", "Apartment 3", "Apartment 4", "Apartment 5", "Apartment 6"]
	ADDRESS_ZIP_CODE         					= ["1111-111", "2222-222", "3333-333", "4444-444", "5555-555", "6666-666"]
	ADDRESS_LAT              					= ["10", "20", "30", "40", "50", "60"]
	ADDRESS_LNG              					= ["10", "20", "30", "40", "50", "60"]
	
	current_date = DateTime.current.to_date
	30.times { |i| DATE << current_date - i.days }
	DATE.each do |date|
		product = { name:           "Prod #{SecureRandom.uuid}",
		            product_type:   PRODUCT_PRODUCT_TYPE.sample,
		            environment_id: ENVIRONMENT.sample,
		            created_at:     date,
		            updated_at:     date }
		insert_single_product(product)

		customer_document_type = CUSTOMER_DOCUMENT_TYPE.sample
		customer_document_value = case customer_document_type.downcase
										 when 'dni'
											 CUSTOMER_DOCUMENT_VALUE_DNI.sample
										 when 'passport'
											 CUSTOMER_DOCUMENT_VALUE_PASSPORT.sample
										 when 'cc'
											 CUSTOMER_DOCUMENT_VALUE_CC.sample
										 else
											 nil
										 end
		customer = { full_name:      "Customer #{SecureRandom.uuid}",
		             document_type:  customer_document_type,
		             document_value: customer_document_value,
		             environment_id: ENVIRONMENT.sample,
		             customer_type:  CUSTOMER_CUSTOMER_TYPE.sample,
		             created_at:     date,
		             updated_at:     date }
		insert_single_customer(customer)
		
		current_customer = Customer.all.pluck(:id)
		service          = { service_identifier: "Service #{SecureRandom.uuid}",
		                     state:              SERVICE_STATE.sample,
		                     reserved:           SERVICE_RESERVED.sample,
		                     notes:              SERVICE_NOTES.sample,
		                     customer_id:        current_customer.sample,
		                     environment_id:     ENVIRONMENT.sample,
		                     created_at:         date,
		                     updated_at:         date }
		insert_single_service(service)
		
		address = { country:          ADDRESS_COUNTRY.sample,
		            state:            ADDRESS_STATE.sample,
		            city:             ADDRESS_CITY.sample,
		            neighbh:          ADDRESS_NEIGHBH.sample,
		            st_name:          ADDRESS_ST_NAME.sample,
		            st_number:        ADDRESS_ST_NUMBER.sample,
		            floor_number:     ADDRESS_FLOOR_NUMBER.sample,
		            apartment_number: ADDRESS_APARTMENT_NUMBER.sample,
		            lat:              ADDRESS_LAT.sample,
		            lng:              ADDRESS_LNG.sample,
		            created_at:       date,
		            updated_at:       date }
		insert_single_address(address)
	end
end
