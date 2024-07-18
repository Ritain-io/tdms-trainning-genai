# frozen_string_literal: true

require 'rails_helper'

describe ProductsController, type: :controller do
  render_views

  before(:each) do
    @product = Db::Helper.product
  end

  let(:page) { Capybara::Node::Simple.new(response.body) }

  describe 'GET index' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      get :index

      expect(response).to have_http_status(:success)
      expect(page).to have_content(@product.name)
      expect(assigns(:products).first).to eql(@product)
    end
  end

  describe 'GET show' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      get :show, params: { id: @product.id }
      expect(response).to have_http_status(:success)
      expect(page).to have_content(@product.name)
      expect(assigns(:product)).to eql(@product)
    end
  end

  describe 'GET edit' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      get :edit, params: { id: @product.id }
      expect(response).to have_http_status(:success)
      expect(assigns(:product)).to eql(@product)
    end
  end

  describe 'Post new' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      post :new, params: { product: 'test' }
      expect(response).to have_http_status(:success)
    end
  end

  after(:all) do
    Db::Helper.clean
  end
end
