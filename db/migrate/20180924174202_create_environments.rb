# frozen_string_literal: true

class CreateEnvironments < ActiveRecord::Migration[7.0]
  def change
    create_table :environments do |t|
      t.string :name
      t.string :url
      t.boolean :obfuscation, null: false, default: false
      t.timestamps
    end

    add_index :environments, %i[name url], unique: true
  end
end
