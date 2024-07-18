# frozen_string_literal: true

module Api
  module Permissions
    def self.get_all_permissions
      {
        headers: Table::Headers.get_headers(self),
        data: Permission.all.map { |permission| PermissionSerializer.new(permission).as_json }
      }
    end

    def self.create_permission(params)
      Permission.create!(params)
    end

    def self.update_permission(permission, params)
      permission.update(params)
    end
  end
end
