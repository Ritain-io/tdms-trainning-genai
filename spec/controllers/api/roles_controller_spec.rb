# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::RolesController, type: :controller do
  before(:each) do
    @user = Db::Helper.user
    Db::Helper.assign_permission_to_user(@user.id)

    allow(controller).to receive(:current_api_v1_user).and_return(@user)
  end

  describe 'Given roles' do
    it 'Should all roles' do
      Db::Helper.role

      get :index

      expect(response.status).to eql(200)
      expect(JSON.parse(response.body)).not_to eql([])
    end
  end

  describe 'Given a request to show api' do
    it 'Should return role' do
      role = Db::Helper.role
      get :show, params: { id: role.id }

      expect(response.status).to eql(200)
      expect(JSON.parse(response.body).try(:[], 'name')).to eql(role.name)
    end
  end

  describe 'Given a request to create api' do
    it 'Should return success and create role' do
      params = { name: 'create_role' }

      post :create, params: params

      expect(response.status).to eql(200)
      expect(JSON.parse(response.body).try(:[], 'message')).to be_truthy
    end
  end

  describe 'Given a request to update api' do
    it 'Should return success and update role' do
      role = Db::Helper.role
      params = { id: role.id, name: 'update_role' }

      put :update, params: params

      expect(response.status).to eql(200)
      expect(Role.find(role.id).name).to eql('update_role')
      expect(JSON.parse(response.body).try(:[], 'message')).to be_truthy
    end
  end

  describe 'Given a request to delete a role by id for api' do
    it 'Should return success and delete role' do
      role = Db::Helper.role

      delete :destroy, params: { id: role.id }

      expect(response.status).to eql(200)
      expect(JSON.parse(response.body).try(:[], 'message')).to be_truthy
    end
  end

  after(:all) do
    Db::Helper.clean
  end
end
