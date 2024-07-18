# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record, :environment

  def initialize(user, record)
    @user        = user.user
    @record      = record
    @environment = user.environment
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
