# frozen_string_literal: true

class UserRole < ActiveRecord::Base
  belongs_to :environment, inverse_of: :user_roles, optional: true

  belongs_to :user, inverse_of: :user_roles

  belongs_to :role, inverse_of: :user_roles

  has_paper_trail ignore: %i[created_at updated_at]
end
