module Views
	class ProductView < ApplicationRecord
		
		def self.refresh
			Scenic.database.refresh_materialized_view('product_views', concurrently: false, cascade: false)
		end
	end
end
