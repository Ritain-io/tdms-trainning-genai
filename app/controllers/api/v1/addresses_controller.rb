# frozen_string_literal: true
require 'will_paginate/array'

module Api
	module V1
		class AddressesController < ::Api::ApiController
			skip_before_action :verify_authenticity_token, only: %i[index show create delete update import basic_info get_graph]
			before_action :authenticate_api_v1_user!
			before_action :authorize_user
			before_action :load_address, only: %i[show update]
			
			def index
				addresses = Api::Addresses.get_all_addresses(controller_name, permitted_params)
				if addresses.present?
					resp        = Utils::parse_response(response, controller_name, addresses)
					resp[:data] = resp[:data].paginate(helpers.array_pagination(params))
					render json: resp, status: :ok
				else
					render json: { message: 'No Addresses available.' }
				end
			end
			
			def show
				if @address
					render json: @address, status: :ok, action: 'show'
				else
					render json: { message: Api::V1::RECORD_NOT_FOUND }, status: 404
				end
			end
			
			def create
				if Address.where(Utils::translate_params(controller_name, permitted_params)).present?
					render json: { message: 'Record already exists!' }, status: :bad_request
				else
					Api::Addresses.create_address(params)
					render json: { message: true }, status: :ok
				end
			end
			
			def update
				if update_params.permitted?
					Api::Addresses.update_address(@address, update_params)
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
				render json: Api::Addresses.import(params), status: :ok
			end
			
			def basic_info
				addresses_info = Api::Addresses.basic_info(params.try(:[], :environment_id))
				if addresses_info.present?
					render json: addresses_info, status: :ok
				else
					render json: { message: 'No addresses' }
				end
			end
			
			def get_graph
				# if params.try(:[], :environment_id).present?
				data = Api::Addresses.get_graph(params)
				render json: data, status: :ok
				# else
				#	render json: { message: Api::V1::INVALID_PARAMETERS }, status: :bad_request
				# end
			end
			
			private
			
			# Use callbacks to share common setup or constraints between actions.
			def load_address
				@address = Address.find(params.try(:[], :id))
			rescue ActiveRecord::RecordNotFound => e
				# don't raise exception when don't exists
				@address = nil
			end
			
			def permitted_params
				params.permit(:country, :state, :city, :neighbh, :st_name, :environment_id, :st_number, :floor_number,
				              :apartment_number, :zip_code, :lat, :lng, :created_at, :updated_at)
			end
			
			def update_params
				params.permit(:id, :country, :state, :city, :neighbh, :st_name, :environment_id, :st_number, :floor_number,
				              :apartment_number, :zip_code, :lat, :lng, :created_at, :updated_at)
			end
		end
	end
end
