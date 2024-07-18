# frozen_string_literal: true

require 'rails_helper'

describe UsersController, type: :controller do
  render_views

  before(:each) do
    @user = Db::Helper.user
  end

  let(:page) { Capybara::Node::Simple.new(response.body) }

  describe 'GET index' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      get :index

      expect(response).to have_http_status(:success)
      expect(page).to have_content(@user.email)
      expect(assigns(:users).first).to eql(@user)
    end
  end

  after(:all) do
    Db::Helper.clean
  end
end
