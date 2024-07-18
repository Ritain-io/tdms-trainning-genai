# frozen_string_literal: true

FactoryBot.define do
  factory :admin_user do
    sequence(:email) { |n| "email#{n}@email.com" }
    password { '123456' }
    password_confirmation { '123456' }
    # reset_password_token { }
    # reset_password_sent_at {}
    # remember_created_at {}
    # confirmation_token {}
    # confirmed_at {}
    # confirmation_sent_at { }
    # unconfirmed_email {}
  end
end
