# frozen_string_literal: true
require 'will_paginate/array'

module Api
	module V1
		class ServicesController < ::Api::ApiController
			skip_before_action :verify_authenticity_token, only: %i[index show create delete update basic_info get_graph]
			before_action :authenticate_api_v1_user!
			before_action :authorize_user
			before_action :load_service, only: %i[show update]
			
			def index
				if params.try(:[], :environment_id)
					services = Api::Services.get_all_services(controller_name, filter_params,current_api_v1_user)
					if services.present?
						resp        = Utils::parse_response(response, controller_name, services)
						resp[:data] = resp[:data].paginate(helpers.array_pagination(params))
						render json: resp, status: :ok
					else
						render json: { message: 'No services for this environment' }
					end
				else
					render json: { message: Api::V1::INVALID_PARAMETERS }, status: :bad_request
				end
			end
			
			def show
				if @service
					render json: Api::Services.show_service(@service, current_api_v1_user), status: :ok
				else
					render json: { message: Api::V1::RECORD_NOT_FOUND }, status: 404
				end
			end
			
			def create
				if params.try(:[], :environment_id)
					Api::Services.create_service(create_params)
					render json: { message: true }, status: :ok
				else
					render json: { message: Api::V1::INVALID_PARAMETERS }, status: :bad_request
				end
			end
			
			def update
				if update_params.permitted?
					Api::Services.update_service(@service, update_params)
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
				services_info = Api::Services.basic_info(params.try(:[], :environment_id))
				if services_info.present?
					render json: services_info, status: :ok
				else
					render json: { message: 'No services' }
				end
			end
			
			def get_graph
				if params.try(:[], :environment_id).present?
					data = Api::Services.get_graph(params, current_api_v1_user)
					render json: data, status: :ok
				else
					render json: { message: Api::V1::INVALID_PARAMETERS }, status: :bad_request
				end
			end
			
			private
			
			def load_service
				@service = Service.find(params.try(:[], :id))
			rescue ActiveRecord::RecordNotFound => e
				# don't raise exception when don't exists
				@service = nil
			end
			
			def reservation_params
				params.permit(:name, :customer_id, :customer_full_name, :state, :environment_id)
			end
			
			def create_params
				params.require(:service).permit(:service_identifier, :state, :reserved, :notes, :customer_id, :environment_id)
			end
			
			def filter_params
				params.permit(:service_identifier, :state, :reserved, :notes, :customer, :environment_id, :created_at, :updated_at)
			end
			
			def update_params
				params.permit(:id, :service_identifier, :state, :reserved, :notes, :customer_id, :environment_id)
			end
		end
	end
end
