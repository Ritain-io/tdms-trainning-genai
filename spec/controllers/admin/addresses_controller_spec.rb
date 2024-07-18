# frozen_string_literal: true

require 'rails_helper'

describe AddressesController, type: :controller do
  render_views

  before(:each) do
    @address = Db::Helper.address
  end

  let(:page) { Capybara::Node::Simple.new(response.body) }

  describe 'GET index' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      get :index

      expect(response).to have_http_status(:success)
      expect(page).to have_content(@address.country)
      expect(assigns(:addresses).first).to eql(@address)
    end
  end

  describe 'GET show' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      get :show, params: { id: @address.id }
      expect(response).to have_http_status(:success)
      expect(page).to have_content(@address.country)
      expect(page).to have_content(@address.state)
      expect(page).to have_content(@address.city)
      expect(page).to have_content(@address.neighbh)
      expect(page).to have_content(@address.st_name)
      expect(page).to have_content(@address.st_number)
      expect(page).to have_content(@address.floor_number)
      expect(page).to have_content(@address.apartment_number)
      expect(page).to have_content(@address.zip_code)
      expect(page).to have_content(@address.lat)
      expect(page).to have_content(@address.lng)
      expect(assigns(:address)).to eql(@address)
    end
  end

  describe 'GET edit' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      get :edit, params: { id: @address.id }
      expect(response).to have_http_status(:success)
      expect(assigns(:address)).to eql(@address)
    end
  end

  describe 'Post new' do
    it 'returns http success' do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      admin                          = Db::Helper.admin_user
      sign_in admin

      post :new, params: { country: 'test',
                           state: 'test',
                           city: 'test',
                           neighbh: 'test',
                           st_name: 'test',
                           st_number: 'test',
                           floor_number: 'test',
                           apartment_number: 'test',
                           zip_code: 'test',
                           lat: 'test',
                           lng: 'test' }
      expect(response).to have_http_status(:success)
    end
  end

  after(:all) do
    Db::Helper.clean
  end
end
