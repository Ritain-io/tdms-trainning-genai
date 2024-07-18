# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true
  include Pundit::Authorization
  before_action :set_paper_trail_whodunnit
  after_action :verify_authorized, unless: :active_admin_or_devise?

  def active_admin_or_devise?
    controller_name == 'sessions' || is_a?(ActiveAdmin::BaseController) || devise_controller?
  end

  protected

  def info_for_paper_trail
    environment_id = params.try(:[], controller_name.singularize).try(:[], 'environment_id')
    { environment_id: environment_id, timestamp: DateTime.now.strftime('%d%m%Y') }
  end

  def user_for_paper_trail
    unless devise_controller?
      admin_user_signed_in? ? current_admin_user.try(:id) : 'Unknown user'
    end
  end
end
