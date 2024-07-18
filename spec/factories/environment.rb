# frozen_string_literal: true

FactoryBot.define do
  factory :environment do
    sequence(:name) { |n| "name_ambient_#{n}" }
    sequence(:url) { |n| "url_ambient_#{n}" }
  end
end
