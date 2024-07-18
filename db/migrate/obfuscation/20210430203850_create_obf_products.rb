# frozen_string_literal: true

class CreateObfProducts < ActiveRecord::Migration[7.0]
	def change
		create_table :obf_products do |t|
			t.string :name, null: false, default: ''
			t.string :product_type, null: false, default: ''
			t.string :code
			t.string :sku
			t.references :environment, null: false
			t.timestamps
		end
	end
end
