# frozen_string_literal: true

class CreateUserRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :user_roles do |t|
      t.references :user, null: false
      t.references :role, null: false
      t.references :environment, null: false
      t.timestamps
    end

    add_index :user_roles, %i[user_id environment_id], unique: true
  end
end
