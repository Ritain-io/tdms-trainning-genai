# frozen_string_literal: true

class RolePolicy < ApplicationPolicy
  def show?
    if user.present? && user.has_permission_no_env?('List Roles')
      true
    else
      false
    end
  end

  def index?
    if user.present? && user.has_permission_no_env?('List Roles')
      true
    else
      false
    end
  end

  def create?
    if user.present? && user.has_permission_no_env?('Create Role')
      true
    else
      false
    end
  end

  def update?
    if user.present? && user.has_permission_no_env?('Update Role')
      true
    else
      false
    end
  end

  def delete?
    if user.present? && user.has_permission_no_env?('Delete Role')
      true
    else
      false
    end
  end

  def basic_info?
    if user.present? && user.has_permission_no_env?('List Roles')
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
