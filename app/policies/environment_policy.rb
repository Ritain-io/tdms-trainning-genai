# frozen_string_literal: true

class EnvironmentPolicy < ApplicationPolicy
  def show?
    if user.present? && user.has_permission_no_env?('List Environments')
      true
    else
      false
    end
  end

  def environments_detail?
    true
  end

  def activity?
    true
  end

  def environment_activity?
    true
  end

  def resource_availability?
    true
  end

  def index?
    true
  end

  def create?
    if user.present? && user.has_permission_no_env?('Create Environment')
      true
    else
      false
    end
  end

  def update?
    if user.present? && user.has_permission_no_env?('Update Environment')
      true
    else
      false
    end
  end

  def delete?
    if user.present? && user.has_permission_no_env?('Delete Environment')
      true
    else
      false
    end
  end

  def basic_info?
    if user.present? && user.has_permission_no_env?('List Environments')
      true
    else
      false
    end
  end

  def table_column_names?
    true
  end

  def versions?
    if user.present? && user.has_permission_no_env?('Environment Audit Logs')
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
