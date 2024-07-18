# frozen_string_literal: true

class ProductPolicy < ApplicationPolicy
  def show?
    if user.present? && user.has_permission_no_env?('List Products')
      true
    else
      false
    end
  end

  def index?
    if user.present? && user.has_permission?('List Products', environment)
      true
    else
      false
    end
  end

  def create?
    if user.present? && user.has_permission?('Create Product', environment)
      true
    else
      false
    end
  end

  def update?
    if user.present? && user.has_permission_no_env?('Update Product')
      true
    else
      false
    end
  end

  def delete?
    if user.present? && user.has_permission_no_env?('Delete Product')
      true
    else
      false
    end
  end

  def basic_info?
    if user.present? && user.has_permission_no_env?('List Products')
      true
    else
      false
    end
  end

  def get_graph?
    if user.present? && user.has_permission?('List Products', environment)
      true
    else
      false
    end
  end

  def import?
    if user.present? && user.has_permission?('Create Product', environment)
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
