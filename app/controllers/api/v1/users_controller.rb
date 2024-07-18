# frozen_string_literal: true

module Api
  module V1
    class UsersController < ::Api::ApiController
      skip_before_action :verify_authenticity_token, only: %i[index show create delete update profile]
      before_action :authenticate_api_v1_user!
      before_action :authorize_user
      before_action :load_user, only: %i[show update]

      def profile
        render json: current_api_v1_user, status: :ok
      end

      def index
        users = Api::Users.get_all_users(controller_name, permitted_params)
        if users.present?
          resp        = Utils::parse_response(response, controller_name, users)
          resp[:data] = resp.try(:[], :data).each { |d| d.try(:[], :roles).sort_by { |r| r.try(:[], :name) } }
          render json: resp, status: :ok
        else
          render json: { message: 'No users available' }
        end
      end

      def show
        if @user
          render json: Api::Users.get_user_info(@user), status: :ok, action: 'show'
        else
          render json: { message: Api::V1::RECORD_NOT_FOUND }, status: 404
        end
      end

      def create
        if permitted_params.permitted?
          if User.where(permitted_params).present?
            render json: { message: 'Record already exists!' }, status: :bad_request
          else
            render json: { message: Api::Users.create_user(permitted_params) }, status: :ok
          end
        else
          render json: { message: Api::V1::INVALID_PARAMETERS }, status: :bad_request
        end
      end

      def update
        if update_params.permitted?
          render json: { message: Api::Users.update_user(@user, update_params) }, status: :ok
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

      private

      def load_user
        @user = User.find(params.try(:[], :id))
      rescue ActiveRecord::RecordNotFound => e
        # don't raise exception when don't exists
        @user = nil
      end

      def permitted_params
        params.permit(:first_name, :last_name, :password, :email, :role_id, { settings: {} }, :created_at, :updated_at)
      end

      def update_params
        params.permit(:id, :first_name, :last_name, :password, :email, :role_id, { settings: {} })
      end
    end
  end
end
