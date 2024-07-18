# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::ServicesController, type: :controller do
  before(:each) do
    @user = Db::Helper.user
    Db::Helper.assign_permission_to_user(@user.id)
    @environment = Environment.find_by_name('name_test')
    @customer = Db::Helper.customer({ environment_id: @environment.id })

    allow(controller).to receive(:current_api_v1_user).and_return(@user)
  end

  describe 'Given services' do
    it 'Should all services' do
      Db::Helper.service({ customer_id: @customer.id, environment_id: @environment.id })

      get :index, params: { environment_id: @environment.id }

      expect(response.status).to eql(200)
      expect(JSON.parse(response.body)).not_to eql([])
    end
  end

  describe 'Given a request to show api' do
    it 'Should return service' do
      service = Db::Helper.service({ customer_id: @customer.id, environment_id: @environment.id })
      get :show, params: { id: service.id }

      expect(response.status).to eql(200)
      expect(JSON.parse(response.body).try(:[], 'name')).to eql(service.name)
      expect(JSON.parse(response.body).try(:[], 'notes')).to eql(service.notes)
      expect(JSON.parse(response.body).try(:[], 'state')).to eql(service.state)
      expect(JSON.parse(response.body).try(:[], 'reserved')).to eql(service.reserved)
      expect(JSON.parse(response.body).try(:[], 'customer')).to eql(service.customer.full_name)
    end
  end

  describe 'Given a request to create api' do
    it 'Should return success and create service' do
      params = { name: 'create_service',
                 notes: 'create_service',
                 state: 'create_service',
                 reserved: false,
                 customer_id: @customer.id,
                 environment_id: @environment.id }

      post :create, params: params
      expect(response.status).to eql(200)
      expect(JSON.parse(response.body).try(:[], 'message')).to be_truthy
    end
  end

  describe 'Given a request to update api' do
    it 'Should return success and update service' do
      service = Db::Helper.service({ customer_id: @customer.id, environment_id: @environment.id })
      params = { id: service.id,
                 name: 'update_service',
                 notes: 'update_service',
                 state: 'update_service',
                 reserved: false }

      put :update, params: params

      expect(response.status).to eql(200)
      expect(Service.find(service.id).name).to eql('update_service')
      expect(JSON.parse(response.body).try(:[], 'message')).to be_truthy
    end
  end

  describe 'Given a request to delete a service by id for api' do
    it 'Should return success and delete service' do
      Service.destroy_all
      service = Db::Helper.service({ customer_id: @customer.id, environment_id: @environment.id })
      expect(Service.all.count).to eql(1)

      delete :destroy, params: { id: service.id }

      expect(response.status).to eql(200)
      expect(Service.all.count).to eql(0)
      expect(JSON.parse(response.body).try(:[], 'message')).to be_truthy
    end
  end

  after(:all) do
    Db::Helper.clean
  end
end
