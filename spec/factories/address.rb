# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    sequence(:country) { |n| "country_#{n}" }
    sequence(:state) { |n| "state_#{n}" }
    sequence(:city) { |n| "city_#{n}" }
    sequence(:neighbh) { |n| "neighbh_#{n}" }
    sequence(:st_name) { |n| "st_name_#{n}" }
    sequence(:st_number) { |n| "st_number_#{n}" }
    sequence(:floor_number) { |n| "floor_number_#{n}" }
    sequence(:apartment_number) { |n| "apartment_number_#{n}" }
    sequence(:zip_code) { |n| "zip_code_#{n}" }
    sequence(:lat) { |n| "lat_#{n}" }
    sequence(:lng) { |n| "lng_#{n}" }
  end
end
