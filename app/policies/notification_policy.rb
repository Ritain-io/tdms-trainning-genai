# frozen_string_literal: true

class NotificationPolicy < ApplicationPolicy
  def index?
    if user.present? && user.has_permission_no_env?('List Notifications')
      true
    else
      false
    end
  end

  def update?
    if user.present? && user.has_permission_no_env?('Update Notification')
      true
    else
      false
    end
  end

  def basic_info?
    if user.present? && user.has_permission_no_env?('List Notifications')
      true
    else
      false
    end
  end

  def set_active?
    if user.present? && user.has_permission_no_env?('Update Notification')
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
