# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::ProductsController, type: :controller do
  before(:each) do
    @user = Db::Helper.user
    Db::Helper.assign_permission_to_user(@user.id)

    allow(controller).to receive(:current_api_v1_user).and_return(@user)
  end

  describe 'Given products' do
    it 'Should all products' do
      Db::Helper.product
      get :index

      expect(response.status).to eql(200)
      expect(JSON.parse(response.body)).not_to eql([])
    end
  end

  describe 'Given a request to show api' do
    it 'Should return product' do
      product = Db::Helper.product
      get :show, params: { id: product.id }

      expect(response.status).to eql(200)
      expect(JSON.parse(response.body).try(:[], 'name')).to eql(product.name)
    end
  end

  describe 'Given a request to create api' do
    it 'Should return success and create product' do
      params = {
        name: 'product 1',
        identifier: 'sku-1',
        category: 'cat 1'
      }

      post :create, params: params

      expect(response.status).to eql(200)
      expect(JSON.parse(response.body).try(:[], 'message')).to be_truthy
    end
  end

  describe 'Given a request to update api' do
    it 'Should return success and update product' do
      product = Db::Helper.product
      params = { id: product.id, name: 'update_name' }

      put :update, params: params

      expect(response.status).to eql(200)
      expect(Product.find(product.id).name).to eql('update_name')
      expect(JSON.parse(response.body).try(:[], 'message')).to be_truthy
    end
  end

  describe 'Given a request to delete a product by id for api' do
    it 'Should return success and delete product' do
      Product.destroy_all

      product = Db::Helper.product
      expect(Product.all.count).to eql(1)

      delete :destroy, params: { id: product.id }

      expect(response.status).to eql(200)
      expect(Product.all.count).to eql(0)
      expect(JSON.parse(response.body).try(:[], 'message')).to be_truthy
    end
  end

  after(:all) do
    Db::Helper.clean
  end
end
