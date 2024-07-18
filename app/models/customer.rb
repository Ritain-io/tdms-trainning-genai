# frozen_string_literal: true

class Customer < ActiveRecord::Base
  belongs_to :environment, inverse_of: :customers

  has_many :all_services, class_name: 'Service', dependent: :nullify
  has_many :services, inverse_of: :customer

  has_paper_trail ignore: %i[created_at updated_at]

  def show_customer
    "#{name} (#{document_type&.upcase}: #{document_value})"
  end

end
