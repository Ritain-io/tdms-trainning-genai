# frozen_string_literal: true

module Obfuscations
	class ObfAddress < ActiveRecord::Base
		def self.show_full_address
			"#{country}, #{state}, #{city}, #{st_name} ##{st_number}"
		end
	
	end
end
