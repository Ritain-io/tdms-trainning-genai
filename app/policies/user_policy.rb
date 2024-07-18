# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def show?
    if user.present? && user.has_permission_no_env?('List Users')
      true
    else
      false
    end
  end

  def index?
    if user.present? && user.has_permission_no_env?('List Users')
      true
    else
      false
    end
  end

  def create?
    if user.present? && user.has_permission_no_env?('Create User')
      true
    else
      false
    end
  end

  def update?
    if user.present? && user.has_permission_no_env?('Update User')
      true
    else
      false
    end
  end

  def delete?
    if user.present? && user.has_permission_no_env?('Delete User')
      true
    else
      false
    end
  end

  def profile?
    true
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
