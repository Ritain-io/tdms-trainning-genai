# frozen_string_literal: true

class CreateRolePermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :role_permissions do |t|
      t.references :role, null: false
      t.references :permission, null: false
      t.timestamps
    end

    add_index :role_permissions, %i[permission_id role_id], unique: true, name: 'env_role_permissions'
  end
end
