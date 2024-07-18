# frozen_string_literal: true

module Api
  module V1
    class UserRolesController < ::Api::ApiController
      skip_before_action :verify_authenticity_token, only: %i[index show create update delete associate_user_environment]
      before_action :authenticate_api_v1_user!
      before_action :authorize_user
      before_action :load_user_role, only: %i[show update]

      def index
        user_roles = Api::UserRoles.get_all_user_roles(controller_name, filter_params)
        if user_roles.present?
          resp = Utils::parse_response(response, controller_name, user_roles)
          render json: resp, status: :ok
        else
          render json: { message: 'No user roles' }
        end
      end

      def show
        if @user_role
          render json: @user_role, status: :ok, action: 'show'
        else
          render json: { message: Api::V1::RECORD_NOT_FOUND }, status: 404
        end
      end

      def create
        if permitted_params.permitted?
          if UserRole.where(permitted_params).present?
            render json: { message: 'Record already exists!' }, status: :bad_request
          else
            Api::UserRoles.create_user_role(permitted_params)
            render json: { message: true }, status: :ok
          end
        else
          render json: { message: Api::V1::INVALID_PARAMETERS }, status: :bad_request
        end
      end

      def update
        if update_params.permitted?
          Api::UserRoles.update_user_role(@user_role, update_params)
          render json: { message: true }, status: :ok
        else
          render json: { message: Api::V1::INVALID_PARAMETERS }, status: 404
        end
      end

      def delete
        if params.try(:[], :elements)
          Utils::bulk_delete(controller_name, params.try(:[], :elements))
          render json: { message: 'true' }, status: :ok
        else
          render json: { message: Api::V1::INVALID_PARAMETERS }, status: :bad_request
        end
      end

      def associate_user_environment
        if params.try(:[], :environment_id)
          render json: { message: Api::RolePermissions.associated_user_env(params) }, status: :ok
        else
          render json: { message: Api::V1::RECORD_NOT_FOUND }, status: 404
        end
      end

      private

      def load_user_role
        @user_role = UserRole.find(params.try(:[], :id))
      rescue ActiveRecord::RecordNotFound => e
        # don't raise exception when don't exists
        @user_role = nil
      end

      def permitted_params
        params.permit(:user_id, :role_id, :environment_id, :created_at, :updated_at)
      end

      def filter_params
        params.permit(:user, :role, :environment_id, :created_at, :updated_at)
      end

      def update_params
        params.permit(:id, :user_id, :environment_id, :role_id)
      end
    end
  end
end
