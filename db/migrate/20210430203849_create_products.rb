# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name, null: false, default: ''
      t.string :product_type, null: false, default: ''
      t.string :code
      t.string :sku
      t.references :environment, null: false
      t.timestamps
    end

    add_index :products, %i[name product_type], unique: true
  end
end
