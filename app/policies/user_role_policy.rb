# frozen_string_literal: true

class UserRolePolicy < ApplicationPolicy
  def show?
    if user.present? && user.has_permission_no_env?('List User Roles')
      true
    else
      false
    end
  end

  def index?
    if user.present? && user.has_permission_no_env?('List User Roles')
      true
    else
      false
    end
  end

  def create?
    if user.present? && user.has_permission_no_env?('Create User Role')
      true
    else
      false
    end
  end

  def update?
    if user.present? && user.has_permission_no_env?('Update User Role')
      true
    else
      false
    end
  end

  def delete?
    if user.present? && user.has_permission_no_env?('Delete User Role')
      true
    else
      false
    end
  end

  def associate_user_environment?
    if user.present? && user.has_permission_no_env?('Update User Role')
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
