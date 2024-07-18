# frozen_string_literal: true

class EnvironmentSerializer < ActiveModel::Serializer
  attributes :id, :name, :url, :acronym, :created_at, :updated_at, :audit_logs, :obfuscation

  def acronym
    if object.name.include? '_'
      object.name.split('_').map(&:first).join
    else
      object.name.split.map(&:first).join
    end
  end

  def name
    object.name.titleize
  end

  def audit_logs
    if action == 'show'
      versions = Version.where(item_type: 'Environment', item_id: object.id).order(created_at: :desc)[0..6]

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
