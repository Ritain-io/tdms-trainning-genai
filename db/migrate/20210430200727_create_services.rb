# frozen_string_literal: true

class CreateServices < ActiveRecord::Migration[7.0]
  def change
    create_table :services do |t|
      t.string :service_identifier
      t.string :state
      t.boolean :reserved
      t.string :notes
      t.references :customer, null: false
      t.references :environment, null: false
      t.timestamps
    end
  end
end
