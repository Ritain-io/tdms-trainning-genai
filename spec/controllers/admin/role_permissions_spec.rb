# frozen_string_literal: true

require 'rails_helper'

describe RolePermissionsController, type: :controller do
  render_views

  before(:each) do
    role = Db::Helper.role
    permission = Db::Helper.permission
    environment = Db::Helper.environment
    @role_permission = Db::Helper.role_permission({ role_id: role.id, environment_id: environment.id,
                                                    permission_id: permission.id })
  end

  let(:page) { Capybara::Node::Simple.new(response.body) }

  describe 'GET index' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      get :index

      expect(response).to have_http_status(:success)
      expect(page).to have_content(@role_permission.role.name)
      expect(assigns(:role_permissions).first).to eql(@role_permission)
    end
  end

  describe 'GET show' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      get :show, params: { id: @role_permission.id }
      expect(response).to have_http_status(:success)
      expect(page).to have_content(@role_permission.role_id)
      expect(page).to have_content(@role_permission.permission_id)
      expect(page).to have_content(@role_permission.environment_id)
      expect(assigns(:role_permission)).to eql(@role_permission)
    end
  end

  describe 'GET edit' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      get :edit, params: { id: @role_permission.id }
      expect(response).to have_http_status(:success)
      expect(assigns(:role_permission)).to eql(@role_permission)
    end
  end

  describe 'Post new' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      post :new, params: { role_id: 2,
                           permission_id: 2,
                           environment_id: 1 }
      expect(response).to have_http_status(:success)
    end
  end

  after(:all) do
    Db::Helper.clean
  end
end
