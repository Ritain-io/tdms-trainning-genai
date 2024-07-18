module Views
	class CustomerView < ApplicationRecord
		def self.refresh
			Scenic.database.refresh_materialized_view('customer_views', concurrently: false, cascade: false)
		end
	end
end
