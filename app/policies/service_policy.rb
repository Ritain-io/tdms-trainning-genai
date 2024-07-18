# frozen_string_literal: true

class ServicePolicy < ApplicationPolicy
  def show?
    if user.present? && user.has_permission_no_env?('List Services')
      true
    else
      false
    end
  end

  def index?
    if user.present? && user.has_permission_no_env?('List Services')
      true
    else
      false
    end
  end

  def create?
    if user.present? && user.has_permission_no_env?('Create Service')
      true
    else
      false
    end
  end

  def update?
    if user.present? && user.has_permission_no_env?('Update Service')
      true
    else
      false
    end
  end

  def delete?
    if user.present? && user.has_permission_no_env?('Delete Service')
      true
    else
      false
    end
  end

  def basic_info?
    if user.present? && user.has_permission_no_env?('List Services')
      true
    else
      false
    end
  end

  def get_graph?
    if user.present? && user.has_permission_no_env?('List Services')
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
