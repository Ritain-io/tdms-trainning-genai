# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::UsersController, type: :controller do
  before(:each) do
    @user = Db::Helper.user
    Db::Helper.assign_permission_to_user(@user.id)

    allow(controller).to receive(:current_api_v1_user).and_return(@user)
  end

  describe 'Given users' do
    it 'Should all users' do
      get :index

      expect(response.status).to eql(200)
      expect(JSON.parse(response.body)).not_to eql([])
    end
  end

  describe 'Given a request to show api' do
    it 'Should return user' do
      get :show, params: { id: @user.id }

      expect(response.status).to eql(200)
      expect(JSON.parse(response.body).try(:[], 'email')).to eql(@user.email)
    end
  end

  describe 'Given a user' do
    it 'It should return current user info' do
      get :profile

      expect(response.status).to eql(200)
      expect(JSON.parse(response.body).try(:[], 'email')).to eql(@user.email)
    end
  end

  after(:all) do
    Db::Helper.clean
  end
end
