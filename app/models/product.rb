# frozen_string_literal: true

class Product < ActiveRecord::Base
  belongs_to :environment, inverse_of: :products

  has_paper_trail ignore: %i[created_at updated_at]
end
