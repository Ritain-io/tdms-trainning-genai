# frozen_string_literal: true

require 'rails_helper'

describe EnvironmentsController, type: :controller do
  render_views

  before(:each) do
    @environment = Db::Helper.environment
  end

  let(:page) { Capybara::Node::Simple.new(response.body) }

  describe 'GET index' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      get :index

      expect(response).to have_http_status(:success)
      expect(page).to have_content(@environment.name)
      expect(assigns(:environments).first).to eql(@environment)
    end
  end

  describe 'GET show' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      get :show, params: { id: @environment.id }
      expect(response).to have_http_status(:success)
      expect(page).to have_content(@environment.name)
      expect(page).to have_content(@environment.url)
      expect(assigns(:environment)).to eql(@environment)
    end
  end

  describe 'GET edit' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      get :edit, params: { id: @environment.id }
      expect(response).to have_http_status(:success)
      expect(assigns(:environment)).to eql(@environment)
    end
  end

  describe 'Post new' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      post :new, params: { name: 'test', url: 'test' }
      expect(response).to have_http_status(:success)
    end
  end

  after(:all) do
    Db::Helper.clean
  end
end
