# frozen_string_literal: true

FactoryBot.define do
  factory :service do
    sequence(:name) { |n| "service_name_#{n}" }
    sequence(:notes) { |n| "notes_#{n}" }
    sequence(:state) { |n| "state_#{n}" }
    reserved { true }
    customer_id {}
    environment_id {}
  end
end
