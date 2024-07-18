# frozen_string_literal: true

class CustomerPolicy < ApplicationPolicy
  def show?
    if user.present? && user.has_permission_no_env?('List Customers')
      true
    else
      false
    end
  end

  def index?
    if user.present? && user.has_permission?('List Customers', environment)
      true
    else
      false
    end
  end

  def create?
    if user.present? && user.has_permission?('Create Customer', environment)
      true
    else
      false
    end
  end

  def update?
    if user.present? && user.has_permission_no_env?('Update Customer')
      true
    else
      false
    end
  end

  def delete?
    if user.present? && user.has_permission_no_env?('Delete Customer')
      true
    else
      false
    end
  end

  def full_info?
    if user.present? && user.has_permission_no_env?('List Customers')
      true
    else
      false
    end
  end

  def basic_info?
    if user.present? && user.has_permission_no_env?('List Customers')
      true
    else
      false
    end
  end

  def import?
    if user.present? && user.has_permission?('Create Customer', environment)
      true
    else
      false
    end
  end

  def get_graph?
    if user.present? && user.has_permission?('List Customers', environment)
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
