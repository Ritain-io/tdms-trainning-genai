# frozen_string_literal: true

FactoryBot.define do
  factory :customer do
    sequence(:full_name) { |n| "name_ambient_#{n}" }
    sequence(:document_type) { |n| "url_ambient_#{n}" }
    sequence(:document_value) { |n| "url_ambient_#{n}" }
    sequence(:customer_type) { |n| "url_ambient_#{n}" }
    environment_id {}
  end
end
