# frozen_string_literal: true

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :all_user_roles, class_name: 'UserRole', dependent: :destroy
  has_many :user_roles, inverse_of: :user

  def has_permission?(permission, environment)
    permission_id = Permission.find_by_name(permission).try(:id)
    user_role     = UserRole.find_by(user_id: id, environment_id: environment)
    return false if user_role.blank?

    RolePermission.where(role_id: user_role.role_id, permission_id: permission_id).present?
  end

  def has_permission_no_env?(permission)
    permission_id = Permission.find_by_name(permission).try(:id)
    user_role     = UserRole.where(user_id: id)
    return false if user_role.blank?

    RolePermission.where(role_id: user_role.pluck(:role_id), permission_id: permission_id).present?
  end
end
