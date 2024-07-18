module Views
	class ServiceView < ApplicationRecord
		
		def self.refresh
			Scenic.database.refresh_materialized_view('service_views', concurrently: false, cascade: false)
		end
		
	end
end
