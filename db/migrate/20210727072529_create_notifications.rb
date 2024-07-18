class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.string :table
      t.string :column
      t.boolean :active
      t.integer :warning_value
      t.string :warning_message
      t.integer :red_flag_value
      t.string :red_flag_message
    end
  end
end
