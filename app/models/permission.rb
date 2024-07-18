# frozen_string_literal: true

class Permission < ActiveRecord::Base
  has_many :all_role_permissions, class_name: 'Permission', dependent: :destroy
  has_many :role_permissions, autosave: true, inverse_of: :permission

  has_paper_trail ignore: %i[created_at updated_at]
end
