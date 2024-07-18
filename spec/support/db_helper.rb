# frozen_string_literal: true

module Db
  module Helper
    def self.user(args = nil)
      if args
        FactoryBot.create :user, args
      else
        FactoryBot.create :user
      end
    end

    def self.admin_user(args = nil)
      if args
        FactoryBot.create :admin_user, args
      else
        FactoryBot.create :admin_user
      end
    end

    def self.environment(args = nil)
      if args
        FactoryBot.create :environment, args
      else
        FactoryBot.create :environment
      end
    end

    def self.customer(args = nil)
      if args
        FactoryBot.create :customer, args
      else
        FactoryBot.create :customer
      end
    end

    def self.address(args = nil)
      if args
        FactoryBot.create :address, args
      else
        FactoryBot.create :address
      end
    end

    def self.permission(args = nil)
      if args
        FactoryBot.create :permission, args
      else
        FactoryBot.create :permission
      end
    end

    def self.role(args = nil)
      if args
        FactoryBot.create :role, args
      else
        FactoryBot.create :role
      end
    end

    def self.role_permission(args = nil)
      if args
        FactoryBot.create :role_permission, args
      else
        FactoryBot.create :role_permission
      end
    end

    def self.user_role(args = nil)
      if args
        FactoryBot.create :user_role, args
      else
        FactoryBot.create :user_role
      end
    end

    def self.service(args = nil)
      if args
        FactoryBot.create :service, args
      else
        FactoryBot.create :service
      end
    end

    def self.product(args = nil)
      if args
        FactoryBot.create :product, args
      else
        FactoryBot.create :product
      end
    end

    def self.assign_permission_to_user(user_id)
      role = role({ name: 'admin_testing' })
      environment = environment({ name: 'name_test', url: 'url_test' })

      assign_permission_to_role(role.id, environment.id)
      user_role({ user_id: user_id, role_id: role.id })
    end

    def self.assign_permission_to_role(role_id, ambient_id)
      YAML.load_file(Rails.root.join('db', 'seeds', 'permissions.yml')).each do |permission|
        permission = permission({ name: permission['name'] })

        if %w[ambient address user role permission product].any? { |str| permission.name.include?(str) }
          role_permission({ role_id: role_id, permission_id: permission.id, environment_id: nil })
        else
          role_permission({ role_id: role_id, permission_id: permission.id, environment_id: ambient_id })
        end
      end
    end

    def self.clean
      Address.delete_all
      Customer.delete_all
      Environment.delete_all
      Permission.delete_all
      RolePermission.delete_all
      Role.delete_all
      UserRole.delete_all
      User.delete_all
      Service.delete_all
      Product.delete_all
    end
  end
end
