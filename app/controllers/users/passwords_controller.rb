# frozen_string_literal: true

module Users
  class PasswordsController < DeviseTokenAuth::PasswordsController
    private

    def render_not_found_error
      render json: { success: true }
    end
  end
end
