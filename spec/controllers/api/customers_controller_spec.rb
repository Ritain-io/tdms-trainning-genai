# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::CustomersController, type: :controller do
  before(:each) do
    @user = Db::Helper.user
    Db::Helper.assign_permission_to_user(@user.id)
    @environment = Environment.find_by_name('name_test')

    allow(controller).to receive(:current_api_v1_user).and_return(@user)
  end

  describe 'Given customers' do
    it 'Should all customers' do
      Db::Helper.customer({ environment_id: @environment.id })

      get :index, params: { environment_id: @environment.id }

      expect(response.status).to eql(200)
      expect(JSON.parse(response.body)).not_to eql([])
    end
  end

  describe 'Given a request to show api' do
    it 'Should return customer' do
      customer = Db::Helper.customer({ environment_id: @environment.id })
      get :show, params: { id: customer.id }

      expect(response.status).to eql(200)
      expect(JSON.parse(response.body).try(:[], 'full_name')).to eql(customer.full_name)
      expect(JSON.parse(response.body).try(:[], 'document_type')).to eql(customer.document_type)
      expect(JSON.parse(response.body).try(:[], 'document_value')).to eql(customer.document_value)
      expect(JSON.parse(response.body).try(:[], 'customer_type')).to eql(customer.customer_type)
    end
  end

  describe 'Given a request to create api' do
    it 'Should return success and create customer' do
      params = { full_name: 'create_customer',
                 document_type: 'create_customer',
                 document_value: 'create_customer',
                 customer_type: 'create_customer',
                 environment_id: @environment.id }

      post :create, params: params

      expect(response.status).to eql(200)
      expect(JSON.parse(response.body).try(:[], 'message')).to be_truthy
    end
  end

  describe 'Given a request to update api' do
    it 'Should return success and update address' do
      customer = Db::Helper.customer({ environment_id: @environment.id })
      params = { id: customer.id,
                 full_name: 'update_customer',
                 document_type: 'update_customer',
                 document_value: 'update_customer',
                 customer_type: 'update_customer' }

      put :update, params: params

      expect(response.status).to eql(200)
      expect(Customer.find(customer.id).full_name).to eql('update_customer')
      expect(JSON.parse(response.body).try(:[], 'message')).to be_truthy
    end
  end

  describe 'Given a request to delete a customer by id for api' do
    it 'Should return success and delete customer' do
      Customer.destroy_all

      customer = Db::Helper.customer({ environment_id: @environment.id })
      expect(Customer.all.count).to eql(1)

      delete :destroy, params: { id: customer.id }

      expect(response.status).to eql(200)
      expect(Customer.all.count).to eql(0)
      expect(JSON.parse(response.body).try(:[], 'message')).to be_truthy
    end
  end

  after(:all) do
    Db::Helper.clean
  end
end
