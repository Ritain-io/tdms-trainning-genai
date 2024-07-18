# frozen_string_literal: true

require 'rails_helper'

describe ServicesController, type: :controller do
  render_views

  before(:each) do
    environment = Db::Helper.environment
    customer = Db::Helper.customer({ environment_id: environment.id })
    @service = Db::Helper.service({ customer_id: customer.id, environment_id: environment.id })
  end

  let(:page) { Capybara::Node::Simple.new(response.body) }

  describe 'GET index' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      get :index

      expect(response).to have_http_status(:success)
      expect(page).to have_content(@service.name)
      expect(assigns(:services).first).to eql(@service)
    end
  end

  describe 'GET show' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      get :show, params: { id: @service.id }
      expect(response).to have_http_status(:success)
      expect(page).to have_content(@service.name)
      expect(page).to have_content(@service.notes)
      expect(page).to have_content(@service.state)
      expect(page).to have_content(@service.reserved)
      expect(page).to have_content(@service.customer_id)
      expect(assigns(:service)).to eql(@service)
    end
  end

  describe 'GET edit' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      get :edit, params: { id: @service.id }
      expect(response).to have_http_status(:success)
      expect(assigns(:service)).to eql(@service)
    end
  end

  describe 'Post new' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      post :new, params: { name: 'test',
                           notes: 'test',
                           state: 'test',
                           reserved: false,
                           environment_id: 1 }
      expect(response).to have_http_status(:success)
    end
  end

  after(:all) do
    Db::Helper.clean
  end
end
