# frozen_string_literal: true

module Api
  module Roles
    def self.get_all_roles(controller_name, params)
      roles = Role.all
      {
        headers: Table::Headers.get_headers(self),
        data:    roles.map { |role| RoleSerializer.new(role).as_json }
      }
    end

    def self.create_role(params, user)
      permissions = params.try(:[], :permissions)

      user_role = UserRole.where(user_id: user.id).try(:first)

      unless user_role.role.name.downcase.include?('admin')
        my_permissions = RolePermission.where(role_id: user_role.role_id).pluck(:permission_id).uniq

        permissions_not_allowed = permissions - my_permissions
        permissions             -= permissions_not_allowed
      end

      role = Role.create!(name: params.try(:[], :name), colors: params.try(:[], :colors))

      permissions&.each do |perm|
        data                 = {}
        data[:permission_id] = perm
        data[:role_id]       = role.id

        RolePermission.create!(data)
      end
    end

    def self.update_role(role, params, user)
      data          = {}
      data[:name]   = params.try(:[], :name) if params.try(:[], :name)
      data[:colors] = params.try(:[], :colors) if params.try(:[], :colors)

      role.update(data) if data.present?

      permissions = params.try(:[], :permissions)

      user_role = UserRole.where(user_id: user.id).try(:first)

      unless user_role.role.name.downcase.include?('admin')
        my_permissions = RolePermission.where(role_id: user_role.role_id).pluck(:permission_id).uniq

        permissions_not_allowed = permissions - my_permissions
        permissions             -= permissions_not_allowed
      end

      RolePermission.where(role_id: role.id).destroy_all unless permissions.nil?

      permissions.each do |permission_id|
        RolePermission.create!(role_id: role.id, permission_id: permission_id)
      end
    end

    def self.get_role(role)
      permissions = Permission.all.map do |per|
        permission     = RolePermission.where(role: role, permission: per)
        has_permission = permission.present? ? true : false
        { id: per.id, name: per.name, has_permission: has_permission }
      end.sort_by { |per| per.try(:[], :has_permission) ? 0 : 1 }

      permissions
    end

    def self.basic_info
      Role.all.map { |role| { id: role.id, name: role.name } }
    end
  end
end
