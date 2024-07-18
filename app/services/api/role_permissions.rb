# frozen_string_literal: true

module Api
  module RolePermissions
    def self.get_all_role_permissions(controller_name, params)
      role_permissions = RolePermission.all
      {
        headers: Table::Headers.get_headers(self),
        data:    role_permissions.map { |role_permission| RolePermissionSerializer.new(role_permission).as_json }
      }
    end

    def self.create_role_permission(params)
      RolePermission.create!(params)
    end

    def self.update_role_permission(params)
      RolePermission.where(role_id: params.try(:[], :role_id))
    end

    def self.associated_user_env(params)
      env_id  = params.try(:[], :environment_id)
      role_id = params.try(:[], :role_id)
      user_id = params.try(:[], :user_id)

      UserRole.find_or_create_by!(user_id: user_id, role_id: role_id, environment_id: env_id)
    end
  end
end
