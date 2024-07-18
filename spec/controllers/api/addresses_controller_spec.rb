# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::AddressesController, type: :controller do
  before(:each) do
    @user = Db::Helper.user
    Db::Helper.assign_permission_to_user(@user.id)

    @user_not_authorized = Db::Helper.user

    allow(controller).to receive(:current_api_v1_user).and_return(@user)
  end

  describe 'Given addresses' do
    it 'Should all addresses' do
      Db::Helper.address

      get :index

      expect(response.status).to eql(200)
      expect(JSON.parse(response.body)).not_to eql([])
    end
  end

  describe 'Given addresses' do
    it 'It should show an unauthorized user message' do
      Db::Helper.address

      get :index

      expect(response.status).to eql(200)
      expect(JSON.parse(response.body)).not_to eql([])
    end
  end

  describe 'Given a request to show api' do
    it 'Should return address' do
      address = Db::Helper.address
      get :show, params: { id: address.id }

      expect(response.status).to eql(200)
      expect(JSON.parse(response.body).try(:[], 'country')).to eql(address.country)
      expect(JSON.parse(response.body).try(:[], 'state')).to eql(address.state)
      expect(JSON.parse(response.body).try(:[], 'city')).to eql(address.city)
      expect(JSON.parse(response.body).try(:[], 'neighbh')).to eql(address.neighbh)
      expect(JSON.parse(response.body).try(:[], 'st_name')).to eql(address.st_name)
      expect(JSON.parse(response.body).try(:[], 'st_number')).to eql(address.st_number)
    end
  end

  describe 'Given a request to create api' do
    it 'Should return success and create address' do
      params = { country: 'create_address',
                 state: 'create_address',
                 city: 'create_address',
                 neighbh: 'create_address',
                 st_name: 'create_address',
                 st_number: 'create_address' }

      post :create, params: params

      expect(response.status).to eql(200)
      expect(JSON.parse(response.body).try(:[], 'message')).to be_truthy
    end
  end

  describe 'Given a request to update api' do
    it 'Should return success and update address' do
      address = Db::Helper.address
      params = { id: address.id,
                 country: 'update_address',
                 state: 'update_address',
                 city: 'update_address',
                 neighbh: 'update_address',
                 st_name: 'update_address',
                 st_number: 'update_address' }

      put :update, params: params

      expect(response.status).to eql(200)
      expect(Address.find(address.id).country).to eql('update_address')
      expect(JSON.parse(response.body).try(:[], 'message')).to be_truthy
    end
  end

  describe 'Given a request to delete a address by id for api' do
    it 'Should return success and delete address' do
      Address.destroy_all

      address = Db::Helper.address
      expect(Address.all.count).to eql(1)

      delete :destroy, params: { id: address.id }

      expect(response.status).to eql(200)
      expect(Address.all.count).to eql(0)
      expect(JSON.parse(response.body).try(:[], 'message')).to be_truthy
    end
  end

  after(:all) do
    Db::Helper.clean
  end
end
