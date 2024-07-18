# frozen_string_literal: true

require 'rails_helper'

describe UserRolesController, type: :controller do
  render_views

  before(:each) do
    user = Db::Helper.user
    role = Db::Helper.role
    @user_role = Db::Helper.user_role({ user_id: user.id, role_id: role.id })
  end

  let(:page) { Capybara::Node::Simple.new(response.body) }

  describe 'GET index' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      get :index

      expect(response).to have_http_status(:success)
      expect(page).to have_content(@user_role.user.first_name)
      expect(assigns(:user_roles).first).to eql(@user_role)
    end
  end

  describe 'GET show' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      get :show, params: { id: @user_role.id }
      expect(response).to have_http_status(:success)
      expect(page).to have_content(@user_role.user_id)
      expect(page).to have_content(@user_role.role_id)
      expect(assigns(:user_role)).to eql(@user_role)
    end
  end

  describe 'GET edit' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      get :edit, params: { id: @user_role.id }
      expect(response).to have_http_status(:success)
      expect(assigns(:user_role)).to eql(@user_role)
    end
  end

  describe 'Post new' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      post :new, params: { user_id: 2,
                           role_id: 1 }
      expect(response).to have_http_status(:success)
    end
  end

  after(:all) do
    Db::Helper.clean
  end
end
