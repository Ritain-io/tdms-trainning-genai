# frozen_string_literal: true

module Users
  class SessionsController < DeviseTokenAuth::SessionsController

    private

    def render_create_success
      user_role = UserRole.find_by_user_id(@resource.id)
      json      = {
        id:          @resource.id,
        first_name:  @resource.first_name,
        last_name:   @resource.last_name,
        email:       @resource.email,
        avatar_data: @resource.avatar_data,
        role:        user_role.present? ? user_role&.role&.name : nil
      }

      render json: { data: json }
    end
  end
end
