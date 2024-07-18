# frozen_string_literal: true

module Api
  module Environments
    def self.parse_environments(controller_name, params)
      sidebar_views = Rails.configuration.sidebar_views
      environments  = Environment.where(Utils::filter_params(controller_name, params))
      data          = {
        environment:       environments.map { |env| EnvironmentSerializer.new(env).as_json },
        global_views:      sidebar_views.try(:[], :global_views),
        environment_views: sidebar_views.try(:[], :environment_views)
      }

      { headers: Table::Headers.get_headers(self), data: data }
    end

    def self.parse_environments_detail(user)
      views             = Rails.configuration.sidebar_views
      environment_views = views.try(:[], :environment_views)
      environments      = Environment.all.map do |env|
        {
          id:     env.id,
          name:   env.name,
          route:  env.url,
          counts: environment_views.map do |table|
            table_name = table.titleize.remove(' ').singularize.constantize
            environment = table_name.where(environment_id: env.id)

            if table == 'addresses' && table_name.has_attribute?('used')
              available   = environment.where(used: false).count
              unavailable = environment.where(used: true).count
              damaged     = environment.where(used: nil).count
            elsif table_name.has_attribute?('reserved')
              available   = environment.where(reserved: false).count
              unavailable = environment.where(reserved: true).count
              damaged     = environment.where(reserved: nil).count
            elsif table_name.has_attribute?('used')
              available   = environment.where(used: false).count
              unavailable = environment.where(used: true).count
              damaged     = environment.where(used: nil).count
            else
              available   = environment.count
              unavailable = 0
              damaged     = 0
            end

            {
              name:  table,
              count: {
                available:   available,
                reserved:    unavailable,
                unavailable: damaged
              }
            }
          end
        }
      end

      {
        environments:  environments,
        global_counts: views.try(:[], :global_views).map do |table|
          {
            name:  table,
            count: table.titleize.remove(' ').singularize.constantize.all.count
          }
        end
      }
    end

    def self.create_environment(params)
      Environment.create!(params)
    end

    def self.update_environment(environment, params)
      environment.update(params)
    end

    def self.get_activity(params)
      start_date = params.try(:[], :start_date) ? params.try(:[], :start_date).to_date : DateTime.now - 1.week
      end_date   = params.try(:[], :end_date) ? params.try(:[], :end_date).to_date : DateTime.now

      all_dates = (start_date..end_date).map { |date| date.strftime('%d%m%Y') }

      data = Environment.all.map do |env|
        activity = []
        all_dates.each do |date|
          versions_count = Version.where(environment_id: env.id, timestamp: date).count
          count          = if versions_count.zero?
                             nil
                           else
                             versions_count
                           end
          activity << count
        end
        [env.name, activity]
      end
      { data: data, time_serie: all_dates }
    end

    def self.get_environment_activity(params)
      environment = Environment.find(params.try(:[], :environment_id))
      start_date  = params.try(:[], :start_date) ? params.try(:[], :start_date).to_date : DateTime.now - 1.week
      end_date    = params.try(:[], :end_date) ? params.try(:[], :end_date).to_date : DateTime.now

      all_dates = (start_date..end_date).map { |date| date.strftime('%d%m%Y') }

      environment_tables = Rails.configuration.sidebar_views.try(:[], :environment_views)

      data = environment_tables.map do |table|
        activity = []
        all_dates.each do |date|
          versions_count = Version.where(environment_id: environment.id, item_type: table.titleize.remove(' ').singularize,
                                         timestamp:      date).count
          count          = if versions_count.zero?
                             nil
                           else
                             versions_count
                           end
          activity << count
        end
        { table.to_sym => activity }
      end

      { data: [environment.name, data], time_serie: all_dates }
    end

    def self.get_resource_availability(params, user)
      environment_tables = Rails.configuration.sidebar_views.try(:[], :environment_views)
      environment_tables = environment_tables

      data       = environment_tables.map do |table|
        table_name = table.titleize.remove(' ').singularize.constantize
        environment = table_name.where(environment_id: params.try(:[], :environment_id))

        if table_name.has_attribute?('reserved')
          available   = environment.where(reserved: false).count
          unavailable = environment.where(reserved: true).count
          damaged     = environment.where(reserved: nil).count
        elsif table_name.has_attribute?('used')
          available   = environment.where(used: false).count
          unavailable = environment.where(used: true).count
          damaged     = environment.where(used: nil).count
        elsif table.to_s != 'customers'
          available   = environment.count
          unavailable = 0
          damaged     = 0
        end

        if table.to_s == 'customers'
          customers = Customer.where(environment_id: params.try(:[], :environment_id))

          customer_count = customers.pluck(:state).map { |s| s&.downcase }.uniq.map do |state|
            if state.blank?
              { name: 'unavailable', count: customers.where(state: state).count }
            else
              { name: state.downcase, count: customers.where("state ilike '#{state}'").count }
            end
          end

          { name: table, availability: customer_count, notification: Notification.find_by_table(table_name.to_s).try(:[], :active), table: table_name.to_s }
        else
          {
            name:         table,
            availability: [{ name: 'available', count: available },
                           { name: 'reserved', count: unavailable },
                           { name: 'unavailable', count: damaged }],
            notification: Notification.find_by_table(table_name.to_s).try(:[], :active),
            table:        table_name.to_s
          }
        end
      end
      role       = UserRole.find_by_user_id(user.id).try(:[], :role_id)
      permission = Permission.find_by_name('Update Notification').try(:[], :id)

      { tables: data, permission: RolePermission.find_by(role_id: role, permission_id: permission).present? }
    end

    def self.basic_info
      Environment.all.map { |environment| { id: environment.id, name: environment.name } }
    end

    def self.table_column_names(table)
      result = table.titleize.remove(' ').singularize.constantize.column_names - %w[id updated_at created_at environment_id]

      default = case table
                  when 'addresses'
                    'country'
                  when 'customers'
                    'customer_type'
                  when 'products'
                    'product_type'
                  when 'services'
                    'state'
                  else
                    nil
                end

      { result: result.map { |t| { name: t } }, default: { name: default } }
    end

    def self.get_versions(environment, params)
      start_date = params.try(:[], :start_date) ? params.try(:[], :start_date) : DateTime.now - 1.week
      end_date   = params.try(:[], :end_date) ? params.try(:[], :end_date) : DateTime.now

      versions_by_date = Version.where("created_at >= ? AND created_at <= ?", start_date.to_time, end_date.to_time)

      tables   = Rails.configuration.sidebar_views.try(:[], :environment_views).map { |x| x.singularize.titleize.delete(' ') }
      versions = versions_by_date.where(environment_id: environment.id, item_type: tables).map do |version|
        user      = User.find(version.whodunnit)
        user_name = user.first_name.present? ? "#{user.first_name} #{user.last_name}" : user.email
        { table: version.item_type, action: version.event, user: user_name, date: version.created_at, changes: JSON.parse(version.object_changes).map { |key, value| { key.to_sym => { before: value[0], after: value[1] } } } }
      end
      { headers: %w(table action user date), data: versions.sort_by { |v| v.try(:[], :date) }.reverse }
    end
  end
end
