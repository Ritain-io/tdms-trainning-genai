# frozen_string_literal: true

FactoryBot.define do
  factory :permission do
    sequence(:name) { |n| "name_permission_#{n}" }
  end
end
