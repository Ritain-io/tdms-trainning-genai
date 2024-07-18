# frozen_string_literal: true

FactoryBot.define do
  factory :role_permission do
    role_id {}
    permission_id {}
    environment_id {}
  end
end
