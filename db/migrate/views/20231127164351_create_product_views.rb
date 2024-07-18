class CreateProductViews < ActiveRecord::Migration[7.0]
  def change
    create_view :product_views, materialized: true
  end
end
