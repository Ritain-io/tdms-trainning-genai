# frozen_string_literal: true

class ExternalJob < ActiveRecord::Base
  belongs_to :environment, inverse_of: :external_jobs

  has_paper_trail ignore: %i[created_at updated_at]
end
