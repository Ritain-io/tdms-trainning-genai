# frozen_string_literal: true

class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :table, :column, :active, :warning_value, :warning_message, :red_flag_value, :red_flag_message, :audit_logs

  def audit_logs
    if action == 'show'
      versions = Version.where(item_type: 'Notification', item_id: object.id).order(created_at: :desc)[0..6]

      versions.map do |v|
        object_changes = JSON.parse(v.object_changes)
        record_changes = object_changes.map { |key, value| { key.to_sym => { before: value[0], after: value[1] } } }

        #This needs to be this way because of unit testing
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
