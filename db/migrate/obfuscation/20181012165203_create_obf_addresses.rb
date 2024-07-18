# frozen_string_literal: true

class CreateObfAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :obf_addresses do |t|
      t.string :country, null: false, default: ''
      t.string :state, null: false, default: ''
      t.string :city, null: false, default: ''
      t.string :neighbh, null: false, default: ''
      t.string :st_name, null: false, default: ''
      t.string :st_number, null: false, default: ''
      t.string :floor_number, null: false, default: ''
      t.string :apartment_number, null: false, default: ''
      t.string :zip_code, null: false, default: ''
      t.float :lat, default: 0.0
      t.float :lng, default: 0.0
      t.references :environment, null: false
      t.timestamps
    end
  end
end
