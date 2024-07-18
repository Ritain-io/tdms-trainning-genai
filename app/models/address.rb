# frozen_string_literal: true

class Address < ActiveRecord::Base
  # belongs_to :environment, inverse_of: :addresses

  has_paper_trail ignore: %i[created_at updated_at]

  def self.show_full_address
    "#{country}, #{state}, #{city}, #{st_name} ##{st_number}"
  end
end
