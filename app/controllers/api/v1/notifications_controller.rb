# frozen_string_literal: true
require 'will_paginate/array'

module Api
  module V1
    class NotificationsController < ::Api::ApiController
      skip_before_action :verify_authenticity_token, only: %i[index update basic_info set_active]
      before_action :authenticate_api_v1_user!
      before_action :authorize_user
      before_action :load_notification, only: %i[update]

      def index
        notifications = Api::Notifications.get_all_notifications
        if notifications.present?
          resp                   = Utils::parse_response(response, controller_name, notifications)
          resp[:data]            = resp[:data].paginate(helpers.array_pagination(params))
          resp[:modal_relations] = [{ api_name: 'notifications', modal_name: 'column' }]
          render json: resp, status: :ok
        else
          render json: { message: 'No notifications available.' }
        end
      end

      def update
        if update_params.permitted?
          Api::Notifications.update_notification(@notification, update_params)
        else
          render json: { message: Api::V1::INVALID_PARAMETERS }, status: 404
        end
      end

      def basic_info
        if params.try(:[], :table)
          render json: Api::Notifications.get_column_names(params.try(:[], :table)), status: :ok
        else
          render json: { message: Api::V1::INVALID_PARAMETERS }, status: 404
        end
      end

      def set_active
        if params.try(:[], :table)
          notification = Api::Notifications.set_active(params.try(:[], :table))
          if notification.nil?
            render json: { message: 'notification not updated!' }, status: :bad_request
          else
            render json: notification, status: :ok
          end
        else
          render json: { message: Api::V1::INVALID_PARAMETERS }, status: 404
        end
      end

      private

      def load_notification
        @notification = Notification.find(params.try(:[], :id))
      rescue ActiveRecord::RecordNotFound => e
        # don't raise exception when don't exists
        @notification = nil
      end

      def update_params
        params.permit(:id, :table, :column, :active, :warning_value, :warning_message, :red_flag_value, :red_flag_message)
      end
    end
  end
end
