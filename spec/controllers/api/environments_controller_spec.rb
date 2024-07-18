# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::EnvironmentsController, type: :controller do
  before(:each) do
    @user = Db::Helper.user
    Db::Helper.assign_permission_to_user(@user.id)

    allow(controller).to receive(:current_api_v1_user).and_return(@user)
  end

  describe 'Given environments' do
    it 'Should all environments' do
      Db::Helper.environment

      get :index

      expect(response.status).to eql(200)
      expect(JSON.parse(response.body)).not_to eql([])
    end
  end

  describe 'Given a request to show api' do
    it 'Should return environment' do
      environment = Db::Helper.environment
      get :show, params: { id: environment.id }

      expect(response.status).to eql(200)
      expect(JSON.parse(response.body).try(:[], 'name')).to eql(environment.name.titleize)
      expect(JSON.parse(response.body).try(:[], 'url')).to eql(environment.url)
    end
  end

  describe 'Given a request to create api' do
    it 'Should return success and create environment' do
      params = { name: 'create_environment', url: 'create_environment' }

      post :create, params: params

      expect(response.status).to eql(200)
      expect(JSON.parse(response.body).try(:[], 'message')).to be_truthy
    end
  end

  describe 'Given a request to update api' do
    it 'Should return success and update environment' do
      environment = Db::Helper.environment
      params = { id: environment.id, name: 'update_environment', url: 'update_environment' }

      put :update, params: params

      expect(response.status).to eql(200)
      expect(Environment.find(environment.id).name).to eql('update_environment')
      expect(JSON.parse(response.body).try(:[], 'message')).to be_truthy
    end
  end

  after(:all) do
    Db::Helper.clean
  end
end
