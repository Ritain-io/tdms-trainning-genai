# frozen_string_literal: true
require 'will_paginate/array'

module Api
  module V1
    class EnvironmentsController < ::Api::ApiController
      skip_before_action :verify_authenticity_token,
                         only: %i[index show create update environments_detail activity environment_activity
                                  resource_availability delete versions table_column_names]
      before_action :authenticate_api_v1_user!
      before_action :authorize_user
      before_action :load_environment, only: %i[show update versions]

      def index
        environments = Api::Environments.parse_environments(controller_name, permitted_params)
        response.set_header('Access-Control-Expose-Headers', 'X-Total-Count')
        response.set_header('X-Total-Count', environments.try(:[], :data).try(:[], :environment).count)

        page                              = environments[:data][:environment].paginate(helpers.array_pagination(params))
        environments[:data][:environment] = page
        render json: environments, status: :ok
      end

      def show
        if @environment
          render json: @environment, status: :ok, action: 'show'
        else
          render json: { message: Api::V1::RECORD_NOT_FOUND }, status: 404
        end
      end

      def create
        if permitted_params.permitted?
          if Environment.where(permitted_params).present?
            render json: { message: 'Record already exists!' }, status: :bad_request
          else
            Api::Environments.create_environment(permitted_params)
            render json: { message: true }, status: :ok
          end
        else
          render json: { message: Api::V1::INVALID_PARAMETERS }, status: bad_request
        end
      end

      def update
        if update_params.permitted?
          Api::Environments.update_environment(@environment, update_params)
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

      def environments_detail
        render json: Api::Environments.parse_environments_detail(current_api_v1_user), status: :ok
      end

      def activity
        render json: Api::Environments.get_activity(params), status: :ok
      end

      def environment_activity
        if params.try(:[], :environment_id)
          activity = Api::Environments.get_environment_activity(params)
          render json: activity, status: :ok
        else
          render json: Api::V1::INVALID_PARAMETERS, status: :bad_request
        end
      end

      def resource_availability
        if params.try(:[], :environment_id)
          render json: Api::Environments.get_resource_availability(params, current_api_v1_user), status: :ok
        else
          render json: { message: Api::V1::INVALID_PARAMETERS }, status: :bad_request
        end
      end

      def basic_info
        environments_info = Api::Environments.basic_info
        if environments_info.present?
          render json: environments_info, status: :ok
        else
          render json: { message: 'No environments' }
        end
      end

      def table_column_names
        if params.try(:[], :table)
          render json: Api::Environments.table_column_names(params.try(:[], :table)), status: :ok
        else
          render json: { message: Api::V1::INVALID_PARAMETERS }, status: 404
        end
      end

      def versions
        if @environment
          versions = Api::Environments.get_versions(@environment, params)
          response.set_header('Access-Control-Expose-Headers', 'X-Total-Count')
          response.set_header('X-Total-Count', versions.try(:[], :data).count)

          versions[:data] = versions[:data].paginate(helpers.array_pagination(params))

          render json: versions, status: :ok
        else
          render json: { message: 'No environments' }
        end
      end

      private

      def load_environment
        @environment = Environment.find(params.try(:[], :id))
      rescue ActiveRecord::RecordNotFound => e
        # don't raise exception when don't exists
        @environment = nil
      end

      def permitted_params
        params.permit(:name, :url, :obfuscation, :created_at, :updated_at)
      end

      def update_params
        params.permit(:id, :name, :url, :obfuscation)
      end
    end
  end
end
