# frozen_string_literal: true
require 'will_paginate/array'

module Api
  module V1
    class RolesController < ::Api::ApiController
      skip_before_action :verify_authenticity_token, only: %i[index show create update delete]
      before_action :authenticate_api_v1_user!
      before_action :authorize_user
      before_action :load_role, only: %i[show update]

      def index
        roles = Api::Roles.get_all_roles(controller_name, permitted_params)
        if roles.present?
          resp        = Utils::parse_response(response, controller_name, roles)
          resp[:data] = resp[:data].paginate(helpers.array_pagination(params))
          render json: resp, status: :ok
        else
          render json: { message: 'No roles available.' }
        end
      end

      def show
        if @role.to_json
          role               = JSON.parse(@role.to_json)
          role[:permissions] = Api::Roles.get_role(@role)
          render json: role, status: :ok, action: 'show'
        else
          render json: { message: Api::V1::RECORD_NOT_FOUND }, status: 404
        end
      end

      def create
        if permitted_params.permitted?
          if Role.where(permitted_params).present?
            render json: { message: 'Record already exists!' }, status: :bad_request
          else
            Api::Roles.create_role(params, current_api_v1_user)
            render json: { message: true }, status: :ok
          end
        else
          render json: { message: Api::V1::INVALID_PARAMETERS }, status: bad_request
        end
      end

      def update
        if update_params.permitted?
          Api::Roles.update_role(@role, params, current_api_v1_user)
          render json: { message: true }, status: :ok
        else
          render json: { message: Api::V1::INVALID_PARAMETERS }, status: 404
        end
      end

      def delete
        if params.try(:[], :elements)
          RolePermission.where(role_id: params.try(:[], :elements)).destroy_all
          Utils::bulk_delete(controller_name, params.try(:[], :elements))
          render json: { message: 'true' }, status: :ok
        else
          render json: { message: Api::V1::INVALID_PARAMETERS }, status: :bad_request
        end
      end

      def basic_info
        roles_info = Api::Roles.basic_info
        if roles_info.present?
          render json: roles_info, status: :ok
        else
          render json: { message: 'No roles' }
        end
      end

      private

      def load_role
        @role = Role.find(params.try(:[], :id))
      rescue ActiveRecord::RecordNotFound => e
        # don't raise exception when don't exists
        @role = nil
      end

      def permitted_params
        params.permit(:name, :permissions, :colors, :role, :environment_id, :created_at, :updated_at)
      end

      def update_params
        params.permit(:id, :name, :permissions, :colors, :role, :environment_id)
      end
    end
  end
end
