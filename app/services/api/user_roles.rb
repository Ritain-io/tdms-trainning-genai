# frozen_string_literal: true

module Api
  module UserRoles
    def self.get_all_user_roles(controller_name, params)
      user_roles = UserRole.all
      {
        headers: Table::Headers.get_headers(self),
        data:    user_roles.map { |user_role| UserRoleSerializer.new(user_role).as_json }
      }
    end

    def self.create_user_role(params)
      UserRole.find_or_create_by(params)
    end

    def self.update_user_role(user_role, params)
      user_role.update(params)
    end

    def self.destroy_user_role(user_role)
      user_role.destroy
    end
  end
end
