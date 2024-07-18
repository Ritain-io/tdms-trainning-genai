# frozen_string_literal: true

class Version < ActiveRecord::Base
  belongs_to :environment, inverse_of: :versions
  delegate :name, to: :environment, prefix: true
end
