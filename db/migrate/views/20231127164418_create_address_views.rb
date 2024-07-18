class CreateAddressViews < ActiveRecord::Migration[7.0]
  def change
    create_view :address_views, materialized: true
  end
end
