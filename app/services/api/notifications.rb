# frozen_string_literal: true

module Api
	module Notifications
		def self.get_all_notifications
			validate_tables
			{
				headers: Table::Headers.get_headers(self),
				data:    Notification.all.map { |n| NotificationSerializer.new(n).as_json }
			}
		end
		
		def self.update_notification(notification, params)
			notification.update(params)
		end
		
		def self.get_column_names(table)
			result = table.constantize.column_names - %w[id updated_at created_at environment_id]
			result.map { |t| { name: t } }
		end
		
		def self.set_active(table)
			notification = Notification.find_by_table(table)
			return if notification.blank?
			
			status = notification.update(active: !notification.try(:[], :active))
			
			notification.try(:[], :active) if status
		end
		
		def self.validate_tables
			tables = Rails.configuration.sidebar_views.values.flatten
			tables.map do |table|
				table_sing = table.titleize.remove(' ').singularize
				table_sing if table_sing.constantize.has_attribute?('environment_id')
			end.compact
			new_tables = tables - Notification.all.pluck(:table)
			unless new_tables.blank?
				new_tables.each do |table|
					Notification.create!(table: table, active: false)
				end
			end
		end
	end
end