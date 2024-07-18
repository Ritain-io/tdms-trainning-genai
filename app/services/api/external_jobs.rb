# frozen_string_literal: true
#require 'jenkins2-api'

module Api
  module ExternalJobs
    def self.get_all_jobs(controller_name, params)
      jobs_filtered = ExternalJob.all

      jobs = if params.keys.count == 1
                   jobs_filtered.where(params)
                 else
                   ExternalJob.where(Utils::filter_params(controller_name, params))
                 end
      {
        headers: Table::Headers.get_headers(self) + %w(status last_build active),
        data: parse_info(jobs)
      }
    end

    def self.show_job(job)
      #last_build = parse_last_build(job)
      last_build = nil
      { job_name: job.job_name, cron: job.cron, last_build: last_build.try(:[], :last_build), status: last_build.try(:[], :status),
        last_run: job.last_run, log: last_build.try(:[], :log) }
      # last_run: job.last_run, log: last_build.try(:[], :log), comparison: { name: job.comparison } }
    end

    def self.create_job(params)
      #return 'Job already created' if ExternalJob.find_by(job_name: params.try(:[], :job_name)).present?

      #client = Jenkins2API::Client.new(server: ENV['JENKINS_IP'], username: ENV['JENKINS_USER'], password: ENV['JENKINS_PASS'])
      #jobs   = client.job.list

      #if jobs.pluck('name').map(&:downcase).include? params.try(:[], :job_name).downcase
      ExternalJob.create!(params)
      true
      #else
      #  'Job name not found in Jenkins'
      #end
    end

    def self.update_job(job, params)
      # if params.try(:[], :cron)
      #job_class = get_job_class(job)
      #if job_class
      #  Sidekiq.set_schedule(job.job_name.downcase, { 'cron' => params.try(:[], :cron), 'class' => job_class })
      #end
      #end

      if params.try(:[], :comparison).present?
        ExternalJob.find_by_job_name(params.try(:[], :comparison)).update(comparison: job.job_name)
      end
      job.update(params)
    end

    def self.build_job(job)
      #client = Jenkins2API::Client.new(server: ENV['JENKINS_IP'], username: ENV['JENKINS_USER'], password: ENV['JENKINS_PASS'])
      #client.job.build(job.job_name)
    end

    private

    def self.parse_info(jobs)
      jobs
      # jenkins_jobs = jobs.map do |job|
      #   last_build = parse_last_build(job)
      #   { id:         job.id, job_name: job.job_name, cron: job.cron, comparison: job.comparison,
      #     last_build: last_build.try(:[], :last_build), status: last_build.try(:[], :status),
      #     last_run:   job.last_run, active: nil }
      # end
      #
      # jenkins_jobs.map do |job|
      #   comparison = job.try(:[], :comparison)
      #
      #   if comparison.present?
      #     comparison_job = jenkins_jobs.detect { |jenkins_job| jenkins_job.try(:[], :job_name) == comparison }
      #
      #     if job.try(:[], :last_run) < comparison_job.try(:[], :last_run)
      #       comparison_job.try(:[], :status) == 'SUCCESS' ? job[:active] = false : job[:active] = true
      #     end
      #
      #     if job.try(:[], :last_run) > comparison_job.try(:[], :last_run)
      #       job.try(:[], :status) == 'SUCCESS' ? job[:active] = true : job[:active] = false
      #     end
      #   end
      #   job
      # end
    end

    def self.parse_last_build(job)
      # client = Jenkins2API::Client.new(server: ENV['JENKINS_IP'], username: ENV['JENKINS_USER'], password: ENV['JENKINS_PASS'])
      # begin
      #   last_build = client.build.latest(job.job_name)
      # rescue
      #   return {}
      # end
      # last_timestamp = Time.at(last_build.try(:[], 'timestamp') / 1000).to_datetime
      # job.update!(last_run: last_timestamp)
      # status = if last_build.try(:[], 'building')
      #            'RUNNING'
      #          else
      #            last_build.try(:[], 'result')
      #          end
      # { last_build: last_build.try(:[], 'number'), status: status,
      #   log:        ENV['JENKINS_IP'] + "job/#{job.job_name}/#{last_build.try(:[], 'number')}/logText/progressiveText" }
    end

    #def self.get_job_class(job)
    #end
  end
end