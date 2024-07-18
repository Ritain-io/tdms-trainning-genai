# frozen_string_literal: true

class RolePermission < ActiveRecord::Base
  belongs_to :permission, inverse_of: :role_permissions

  belongs_to :role, inverse_of: :role_permissions

  has_paper_trail ignore: %i[created_at updated_at]
end
