# frozen_string_literal: true

module Api
  module Services
    TABLE = 'Service'
    def self.get_all_services(controller_name, params, user)
      services_filtered = Service.all

      services = if params.keys.count == 1
                   services_filtered.where(params)
                 else
                   services = filter_booleans(services_filtered, params).where(filter_references(params))
                   services.where(Utils::filter_params(controller_name, params)).includes([:customer])
                 end
      {
        headers: Table::Headers.get_headers(self),
        data:    Masking::ObfProcess.list_data(params.dig('environment_id'), services, TABLE, user)
      }
    end
    
    def self.show_service(service, user)
      Masking::ObfProcess.show_data(service, TABLE, user)
    end

    def self.basic_info(env)
      services = if env.nil?
                   Service.all
                 else
                   Service.where(environment_id: env)
                 end

      services.map { |service| { id: service.id, name: service.name } }
    end

    def self.create_service(params)
      data                      = {}
      data[:service_identifier] = params.try(:[], :service_identifier)
      data[:reserved]           = params.try(:[], :reserved)
      data[:notes]              = params.try(:[], :notes)
      data[:customer_id]        = params.try(:[], :customer_id)
      data[:environment_id]     = params.try(:[], :environment_id)

      if params.try(:[], :state).present?
        data[:state] = (params.try(:[], :state) == '-') ? nil : params.try(:[], :state)
      end

      service = Service.create!(data)
      Masking::ObfProcess.new_data(service, TABLE)
    end

    def self.update_service(service, params)
      data                      = {}
      data[:service_identifier] = params.try(:[], :service_identifier) if params.try(:[], :service_identifier)
      data[:reserved]           = params.try(:[], :reserved)
      data[:notes]              = params.try(:[], :notes) if params.try(:[], :notes)
      data[:customer_id]        = params.try(:[], :customer_id) if params.try(:[], :customer_id)
      data[:environment_id]     = params.try(:[], :environment_id) if params.try(:[], :environment_id)

      if params.try(:[], :state).present?
        data[:state] = (params.try(:[], :state) == '-') ? nil : params.try(:[], :state)
      end

      service.update(data)
      Masking::ObfProcess.update_data(params, TABLE)
    end

    def self.get_graph(params, user)
      column              = params.try(:[], :column).present? ? params.try(:[], :column) : 'state'
      environment_id      = params.try(:[], :environment_id)
      is_column_boolean   = Service.columns_hash[column].type == :boolean
      is_column_reference = false

      columns = Service.column_names
      Service._reflections.keys.map do |key|
        is_column_reference = true if (columns.include? "#{key}_id") && ("#{key}_id" == column)
      end.compact

      records = Service.where(environment_id: environment_id)

      grouped_records = records.group_by { |record| record.send(column) }

      data = grouped_records.map do |gr|
        filtered_records = gr.last
        key              = if is_column_reference
                             relations = Utils::convert_relations(column, gr.first)
                             next if relations.blank?
                             relations
                           elsif is_column_boolean
                             Utils::get_boolean_value(column, key)
                           else
                             gr.first
                           end
        available        = filtered_records.select { |y| y.reserved == false }.count
        reserved         = filtered_records.select { |y| y.reserved == true }.count
        unavailable      = filtered_records.select { |y| y.reserved == nil }.count
        { key&.to_sym => [available, reserved, unavailable] }
      end.compact

      
      Masking::ObfProcess.graphs({ data: data, labels: %w[available reserved unavailable] }, environment_id, TABLE, user)
    end

    def self.filter_references(params)
      filter = {}
      if params.try(:[], :customer).present?
        customers = params.try(:[], :customer).split('|').map { |customer| "%#{customer}%" }

        customer_ids         = Customer.where('full_name ilike any (array[?])', customers).pluck(:id)
        filter[:customer_id] = customer_ids
      end
      filter
    end

    def self.filter_booleans(services_filtered, params)
      return services_filtered.where(state: params.try(:[], :state)) if params.try(:[], :state)
      services_filtered
    end
  end
end
