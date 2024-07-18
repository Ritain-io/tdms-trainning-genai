# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "name_#{n}" }
    sequence(:identifier) { |n| "identifier_#{n}" }
    sequence(:category) { |n| "category_#{n}" }
  end
end
