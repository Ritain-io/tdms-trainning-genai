# frozen_string_literal: true

class Service < ActiveRecord::Base
  belongs_to :customer, inverse_of: :services

  belongs_to :environment, inverse_of: :services

  has_paper_trail ignore: %i[created_at updated_at]
end
