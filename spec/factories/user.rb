# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:first_name) { |n| "username_#{n}" }
    sequence(:last_name) { |n| "username_#{n}" }
    sequence(:email) { |n| "test#{n}@test.com" }
    sequence(:password) { |n| "password#{n}" }
  end
end
