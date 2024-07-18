# frozen_string_literal: true

module Api
  module Users
    def self.get_all_users(controller_name, params)
      users = User.all
      users = users.reject { |user| user.email.include?('@ritain.com') }
      {
        headers: Table::Headers.get_headers(self),
        data:    users.map { |user| UserSerializer.new(user).as_json }
      }
    end

    def self.create_user(params)
      user = User.create!(email:     params.try(:[], :email), first_name: params.try(:[], :first_name),
                          last_name: params.try(:[], :last_name), password: "#{params.try(:[], :email).split('@').first}123123")
      #UserMailer.welcome(user).deliver_later
      user
    end

    def self.update_user(user, params)
      user.update(params)
    end

    def self.get_user_info(user)
      user_roles = UserRole.where(user_id: user.id)
      data       = user_roles.map do |user_role|
        { user_role_id: user_role.id, environment: { id: user_role&.environment&.id, name: user_role&.environment&.name }, role: { id: user_role&.role&.id, name: user_role&.role&.name } }
      end
      { user: UserSerializer.new(user).as_json, data: data }
    end
  end
end