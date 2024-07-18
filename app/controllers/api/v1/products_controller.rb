# frozen_string_literal: true
require 'will_paginate/array'

module Api
  module V1
    class ProductsController < ::Api::ApiController
      skip_before_action :verify_authenticity_token, only: %i[index show create update basic_info delete get_graph import]
      before_action :authenticate_api_v1_user!
      before_action :authorize_user
      before_action :load_product, only: %i[show update]

      def index
        if params.try(:[], :environment_id)
          products = Api::Products.get_all_products(controller_name, permitted_params,current_api_v1_user)
          if products.present?
            resp        = Utils::parse_response(response, controller_name, products)
            resp[:data] = resp[:data].paginate(helpers.array_pagination(params))
            render json: resp, status: :ok
          else
            render json: { message: 'No products available.' }
          end
        else
          render json: { message: Api::V1::INVALID_PARAMETERS }, status: :bad_request
        end
      end

      def show
        if @product
          render json: Api::Products.show_product(@product, current_api_v1_user), status: :ok
        else
          render json: { message: Api::V1::RECORD_NOT_FOUND }, status: 404
        end
      end

      def create
        if permitted_params.permitted?
          if Product.where(permitted_params).present?
            render json: { message: 'Record already exists!' }, status: :bad_request
          else
            Api::Products.create_product(permitted_params)
            render json: { message: true }, status: :ok
          end
        else
          render json: { message: Api::V1::INVALID_PARAMETERS }, status: :bad_request
        end
      end

      def update
        if update_params.permitted?
          Api::Products.update_product(@product, update_params)
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

      def basic_info
        products_info = Api::Products.basic_info(params.try(:[], :environment_id))
        if products_info.present?
          render json: products_info, status: :ok
        else
          render json: { message: 'No products' }
        end
      end

      def get_graph
        if params.try(:[], :environment_id).present?
          data = Api::Products.get_graph(params, current_api_v1_user)
          render json: data, status: :ok
        else
          render json: { message: Api::V1::INVALID_PARAMETERS }, status: :bad_request
        end
      end

      def import
        render json: Api::Products.import(params), status: :ok
      end

      private

      def load_product
        @product = Product.find(params.try(:[], :id))
      rescue ActiveRecord::RecordNotFound => e
        # don't raise exception when don't exists
        @product = nil
      end

      def permitted_params
        params.permit(:name, :identifier, :product_type, :code, :environment_id, :sku, :created_at, :updated_at)
      end

      def update_params
        params.permit(:id, :name, :product_type, :code, :environment_id, :sku)
      end
    end
  end
end
