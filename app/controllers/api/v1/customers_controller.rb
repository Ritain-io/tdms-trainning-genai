# frozen_string_literal: true
require 'will_paginate/array'

module Api
  module V1
    class CustomersController < ::Api::ApiController
      skip_before_action :verify_authenticity_token, only: %i[index show create update full_info basic_info delete import get_graph]
      before_action :authenticate_api_v1_user!
      before_action :authorize_user
      before_action :load_customer, only: %i[show update full_info]

      def index
        if index_params.try(:[], :environment_id).present?
          customers = Api::Customers.get_all_customers(controller_name, index_params, current_api_v1_user)
          if customers.present?
            resp        = Utils::parse_response(response, controller_name, customers)
            resp[:data] = resp[:data].paginate(helpers.array_pagination(params))
            render json: resp, status: :ok
          else
            render json: { message: 'No customers for this environment' }
          end
        else
          render json: { message: 'No environment!!' }
        end
      end

      def show
        if @customer
          render json: Api::Customers.show_customer(@customer, current_api_v1_user), status: :ok
        else
          render json: { message: Api::V1::RECORD_NOT_FOUND }, status: 404
        end
      end

      def create
        if params.try(:[], :environment_id)
          if Customer.where(document_value: create_params.try(:[], :document_value)).present?
            render json: { message: 'Record already exists!' }, status: :bad_request
          else
            Api::Customers.create_customer(create_params)
            render json: { message: true }, status: :ok
          end
        else
          render json: { message: Api::V1::INVALID_PARAMETERS }, status: :bad_request
        end
      end

      def update
        if update_params.permitted?
          Api::Customers.update_customer(@customer, update_params)
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

      def import
        render json: Api::Customers.import(params), status: :ok
      end

      def full_info
        if @customer
          render json: Api::Customers.show_customer(@customer, current_api_v1_user), status: :ok
        else
          render json: { message: Api::V1::RECORD_NOT_FOUND }, status: 404
        end
      end

      def basic_info
        customers_info = Api::Customers.basic_info(params.try(:[], :environment_id))
        if customers_info.present?
          render json: customers_info, status: :ok
        else
          render json: { message: 'No customers' }
        end
      end

      def get_graph
        if params.try(:[], :environment_id).present?
          data = Api::Customers.get_graph(params, current_api_v1_user)
          render json: data, status: :ok
        else
          render json: { message: Api::V1::INVALID_PARAMETERS }, status: :bad_request
        end
      end

      private

      def load_customer
        @customer = Customer.find(params.try(:[], :id))
      rescue ActiveRecord::RecordNotFound => e
        # don't raise exception when don't exists
        @customer = nil
      end

      def create_params
        params.require(:customer).permit(:full_name, :document_type, :document_value, :customer_type, :environment_id, :state)
      end

      def index_params
        params.permit(:full_name, :document_type, :document_value, :state, :customer_type, :environment_id,
                      :created_at, :updated_at)
      end

      def update_params
        params.permit(:id, :full_name, :document_type, :document_value, :customer_type, :state, :environment_id)
      end
    end
  end
end
