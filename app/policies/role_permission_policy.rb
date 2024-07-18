# frozen_string_literal: true

class RolePermissionPolicy < ApplicationPolicy
  def show?
    if user.present? && user.has_permission_no_env?('List Role Permissions')
      true
    else
      false
    end
  end

  def index?
    if user.present? && user.has_permission_no_env?('List Role Permissions')
      true
    else
      false
    end
  end

  def create?
    if user.present? && user.has_permission_no_env?('Create Role Permission')
      true
    else
      false
    end
  end

  def update?
    if user.present? && user.has_permission_no_env?('Update Role Permission')
      true
    else
      false
    end
  end

  def delete?
    if user.present? && user.has_permission_no_env?('Delete Role Permission')
      true
    else
      false
    end
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
