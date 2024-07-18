# frozen_string_literal: true
require 'will_paginate/array'

module Api
  module V1
    class RolePermissionsController < ::Api::ApiController
      skip_before_action :verify_authenticity_token, only: %i[index show create update delete]
      before_action :authenticate_api_v1_user!
      before_action :authorize_user
      before_action :load_role_permission, only: %i[show]

      def index
        role_permissions = Api::RolePermissions.get_all_role_permissions(controller_name, filter_params)
        if role_permissions.present?
          resp        = Utils::parse_response(response, controller_name, role_permissions)
          resp[:data] = resp[:data].paginate(helpers.array_pagination(params))
          render json: resp, status: :ok
        else
          render json: { message: 'No role permissions available.' }
        end
      else
        render json: { message: 'No environment!!' }
      end

      def show
        if @role_permission
          render json: @role_permission, status: :ok, action: 'show'
        else
          render json: { message: Api::V1::RECORD_NOT_FOUND }, status: 404
        end
      end

      def create
        if permitted_params.permitted?
          if RolePermission.where(permitted_params).present?
            render json: { message: 'Record already exists!' }, status: :bad_request
          else
            Api::RolePermissions.create_role_permission(permitted_params)
            render json: { message: true }, status: :ok
          end
        else
          render json: { message: Api::V1::INVALID_PARAMETERS }, status: :bad_request
        end
      end

      def update
        if update_params.permitted?
          Api::RolePermissions.update_role_permission(update_params)
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

      private

      def load_role_permission
        @role_permission = RolePermission.find(params.try(:[], :id))
      rescue ActiveRecord::RecordNotFound => e
        # don't raise exception when don't exists
        @role_permission = nil
      end

      def permitted_params
        params.permit(:role_id, :permission_id, :environment_id, :created_at, :updated_at)
      end

      def filter_params
        params.permit(:role, :permission, :environment_id, :created_at, :updated_at)
      end

      def update_params
        params.permit(:id, :role_id, :environment_id)
      end
    end
  end
end
