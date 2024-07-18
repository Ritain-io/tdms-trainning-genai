# frozen_string_literal: true

class Role < ActiveRecord::Base
  has_many :all_user_roles, class_name: 'UserRole', dependent: :destroy
  has_many :user_roles, autosave: true, inverse_of: :role

  has_many :all_role_permissions, class_name: 'RolePermission', dependent: :destroy
  has_many :role_permissions, autosave: true, inverse_of: :role

  has_paper_trail ignore: %i[created_at updated_at]
end
