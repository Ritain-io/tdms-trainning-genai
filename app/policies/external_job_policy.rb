# frozen_string_literal: true

class ExternalJobPolicy < ApplicationPolicy
  def show?
    if user.present? && user.has_permission_no_env?('List Jobs')
      true
    else
      false
    end
  end

  def index?
    if user.present? && user.has_permission_no_env?('List Jobs')
      true
    else
      false
    end
  end

  def create?
    if user.present? && user.has_permission_no_env?('Create Job')
      true
    else
      false
    end
  end

  def update?
    if user.present? && user.has_permission_no_env?('Update Job')
      true
    else
      false
    end
  end

  def destroy?
    if user.present? && user.has_permission_no_env?('Delete Job')
      true
    else
      false
    end
  end

  def build?
    if user.present? && user.has_permission_no_env?('Build Job')
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
