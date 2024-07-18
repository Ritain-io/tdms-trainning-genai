# frozen_string_literal: true
require 'will_paginate/array'

module Api
  module V1
    class ExternalJobsController < ::Api::ApiController
      skip_before_action :verify_authenticity_token, only: %i[index show create update destroy build]
      before_action :authenticate_api_v1_user!
      before_action :authorize_user
      before_action :load_jenkins_job, only: %i[show update destroy build]

      def index
        if params.try(:[], :environment_id).present?
          jobs = Api::ExternalJobs.get_all_jobs(controller_name, permitted_params)
          if jobs.present?
            resp        = Utils::parse_response(response, controller_name, jobs)
            resp[:data] = resp[:data].paginate(helpers.array_pagination(params))
            render json: resp, status: :ok
          else
            render json: { message: 'No jobs available.' }
          end
        else
          render json: { message: 'No environment!!' }
        end
      end

      def show
        if @job
          render json: Api::ExternalJobs.show_job(@job), status: :ok
        else
          render json: { message: Api::V1::RECORD_NOT_FOUND }, status: 404
        end
      end

      def create
        if permitted_params.permitted?
          if ExternalJob.where(permitted_params).present?
            render json: { message: 'Record already exists!' }, status: :bad_request
          else
            render json: { message: Api::ExternalJobs.create_job(permitted_params) }, status: :ok
          end
        else
          render json: { message: Api::V1::INVALID_PARAMETERS }, status: :bad_request
        end
      end

      def update
        if update_params.permitted?
          Api::ExternalJobs.update_job(@job, update_params)
          render json: { message: true }, status: :ok
        else
          render json: { message: Api::V1::INVALID_PARAMETERS }, status: 404
        end
      end

      def destroy
        if @job
          @job.destroy
          render json: { message: true }, status: :ok
        else
          render json: { message: Api::V1::RECORD_NOT_FOUND }, status: 404
        end
      end

      def build
        if @job
          Api::ExternalJobs.build_job(@job)
          render json: { message: true }, status: :ok
        else
          render json: { message: Api::V1::INVALID_PARAMETERS }, status: 404
        end
      end

      private

      def load_jenkins_job
        @job = ExternalJob.find(params.try(:[], :id))
      rescue ActiveRecord::RecordNotFound => e
        # don't raise exception when don't exists
        @job = nil
      end

      def permitted_params
        params.permit(:job_name, :cron, :last_run, :environment_id, :created_at, :updated_at)
      end

      def update_params
        params.permit(:job_name, :cron, :last_run, :environment_id)
      end
    end
  end
end
