class CreateCustomerViews < ActiveRecord::Migration[7.0]
  def change
    create_view :customer_views, materialized: true
  end
end
