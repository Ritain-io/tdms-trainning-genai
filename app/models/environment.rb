# frozen_string_literal: true

class Environment < ActiveRecord::Base
  has_many :all_addresses, class_name: 'Address', dependent: :nullify
  has_many :addresses, inverse_of: :environment

  has_many :all_customers, class_name: 'Customer', dependent: :nullify
  has_many :customers, inverse_of: :environment

  has_many :all_versions, class_name: 'Version', dependent: :nullify
  has_many :versions, inverse_of: :environment

  has_many :all_role_permissions, class_name: 'RolePermission', dependent: :nullify
  has_many :role_permissions, inverse_of: :environment

  has_many :all_user_roles, class_name: 'UserRole', dependent: :nullify
  has_many :user_roles, inverse_of: :environment

  has_many :all_external_jobs, class_name: 'ExternalJob', dependent: :nullify
  has_many :external_jobs, inverse_of: :environment

  has_many :all_products, class_name: 'Product', dependent: :nullify
  has_many :products, inverse_of: :environment

  has_many :all_services, class_name: 'Service', dependent: :nullify
  has_many :services, inverse_of: :environment

  has_paper_trail ignore: %i[created_at updated_at]
end
