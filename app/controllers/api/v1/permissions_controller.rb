# frozen_string_literal: true

module Api
  module V1
    class PermissionsController < ::Api::ApiController
      skip_before_action :verify_authenticity_token, only: %i[index show create update delete]
      before_action :authenticate_api_v1_user!
      before_action :authorize_user
      before_action :load_permission, only: %i[show]

      def index
        permissions = Api::Permissions.get_all_permissions
        if permissions.present?
          render json: permissions, status: :ok
        else
          render json: { message: 'No permissions available.' }
        end
      end

      def show
        if @permission
          render json: @permission, status: :ok
        else
          render json: { message: Api::V1::RECORD_NOT_FOUND }, status: 404
        end
      end

      private

      def load_permission
        @permission = Permission.find(params.try(:[], :id))
      rescue ActiveRecord::RecordNotFound => e
        # don't raise exception when don't exists
        @permission = nil
      end

      def permission_params
        params.require(:permission).permit(:name)
      end
    end
  end
end
