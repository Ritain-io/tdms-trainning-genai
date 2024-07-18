# frozen_string_literal: true

require 'rails_helper'

describe CustomersController, type: :controller do
  render_views

  before(:each) do
    environment = Db::Helper.environment
    @customer = Db::Helper.customer({ environment_id: environment.id })
  end

  let(:page) { Capybara::Node::Simple.new(response.body) }

  describe 'GET index' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      get :index

      expect(response).to have_http_status(:success)
      expect(page).to have_content(@customer.full_name)
      expect(assigns(:customers).first).to eql(@customer)
    end
  end

  describe 'GET show' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      get :show, params: { id: @customer.id }
      expect(response).to have_http_status(:success)
      expect(page).to have_content(@customer.full_name)
      expect(page).to have_content(@customer.document_type)
      expect(page).to have_content(@customer.document_value)
      expect(page).to have_content(@customer.customer_type)
      expect(page).to have_content(@customer.environment_id)
      expect(assigns(:customer)).to eql(@customer)
    end
  end

  describe 'GET edit' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      get :edit, params: { id: @customer.id }
      expect(response).to have_http_status(:success)
      expect(assigns(:customer)).to eql(@customer)
    end
  end

  describe 'Post new' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      post :new, params: { full_name: 'test',
                           document_type: 'test',
                           document_value: 'test',
                           customer_type: 'test',
                           environment_id: 1 }
      expect(response).to have_http_status(:success)
    end
  end

  after(:all) do
    Db::Helper.clean
  end
end
