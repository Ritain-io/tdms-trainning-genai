# frozen_string_literal: true

class ServiceSerializer < ActiveModel::Serializer
	attributes :id, :service_identifier, :state, :reserved, :notes, :customer, :environment, :created_at, :updated_at, :audit_logs
	
	def customer
		{ id: object.customer_id, name: "#{object&.customer&.full_name} (#{object&.customer&.document_type}: #{object&.customer&.document_value})" }
	end
	
	def environment
		{ id: object.environment_id, name: object.environment.name, obfuscation: object.environment.obfuscation }
	end
	
	def audit_logs
		if action == 'show'
			versions = Version.where(item_type: 'Service', item_id: object.id).order(created_at: :desc)[0..6]
			
			versions.map do |v|
				object_changes = JSON.parse(v.object_changes)
				record_changes = object_changes.map { |key, value| { key.to_sym => { before: value[0], after: value[1] } } }
				
				# This needs to be this way because of unit testing
				user = if v.whodunnit.blank?
					       nil
					     else
						     user_version = User.where(id: v.whodunnit).try(:first)
						     if user_version
							     "#{user_version.first_name} #{user_version.last_name}"
						     else
							     nil
						     end
				       end
				
				{ event: v.event, whodunnit: user, date: v.created_at, changes: record_changes }
			end
		end
	end
	
	private
	
	def action
		instance_options[:action]
	end
end
