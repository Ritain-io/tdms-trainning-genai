# frozen_string_literal: true

module Api
  class ApiController < ActionController::Base
    include DeviseTokenAuth::Concerns::SetUserByToken
    include Pundit

    after_action :verify_authorized, unless: :active_admin_or_devise?
    before_action :set_paper_trail_whodunnit
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    def active_admin_or_devise?
      is_a?(ActiveAdmin::BaseController) || devise_controller? || controller_name == 'sessions'
    end

    private

    def pundit_user
      UserPolicies::Context.new(current_api_v1_user, params.try(:[], :environment_id))
    end

    def authorize_user
      authorize(controller_name.classify.constantize)
    end

    def user_not_authorized(_exception)
      render json: { message: 'No permissions to access this request!!!' }, status: :forbidden
    end

    def info_for_paper_trail
      environment_id = params.try(:[], controller_name.singularize).try(:[], 'environment_id')
      { environment_id: environment_id, timestamp: DateTime.now.strftime('%d%m%Y') }
    end

    def user_for_paper_trail
      unless devise_controller?
        current_api_v1_user ? current_api_v1_user.try(:id) : 'Unknown user'
      end
    end
    
    def obfuscation(value)
      Masking::Obfuscate.obfuscate(value)
    end
  end
end
