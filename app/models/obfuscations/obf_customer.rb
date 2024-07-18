# frozen_string_literal: true

module Obfuscations
	class ObfCustomer < ActiveRecord::Base
		def show_customer
			"#{name} (#{document_type&.upcase}: #{document_value})"
		end
	
	end
end
