class CreateServiceViews < ActiveRecord::Migration[7.0]
  def change
    create_view :service_views, materialized: true
  end
end
