# frozen_string_literal: true

require 'rails_helper'

describe PermissionsController, type: :controller do
  render_views

  before(:each) do
    @permission = Db::Helper.permission
  end

  let(:page) { Capybara::Node::Simple.new(response.body) }

  describe 'GET index' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      get :index

      expect(response).to have_http_status(:success)
      expect(page).to have_content(@permission.name)
      expect(assigns(:permissions).first).to eql(@permission)
    end
  end

  describe 'GET show' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      get :show, params: { id: @permission.id }
      expect(response).to have_http_status(:success)
      expect(page).to have_content(@permission.name)
      expect(assigns(:permission)).to eql(@permission)
    end
  end

  describe 'GET edit' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      get :edit, params: { id: @permission.id }
      expect(response).to have_http_status(:success)
      expect(assigns(:permission)).to eql(@permission)
    end
  end

  describe 'Post new' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      post :new, params: { name: 'test' }
      expect(response).to have_http_status(:success)
    end
  end

  after(:all) do
    Db::Helper.clean
  end
end
