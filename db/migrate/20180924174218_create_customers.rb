# frozen_string_literal: true

class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.string :full_name
      t.string :document_type
      t.string :document_value
      t.string :state
      t.references :environment, null: false
      t.timestamps
      t.string :customer_type
    end

    add_index :customers, %i[document_type document_value], unique: true
  end
end
