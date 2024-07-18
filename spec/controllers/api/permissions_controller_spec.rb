# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::PermissionsController, type: :controller do
  before(:each) do
    @user = Db::Helper.user
    Db::Helper.assign_permission_to_user(@user.id)

    allow(controller).to receive(:current_api_v1_user).and_return(@user)
  end

  # describe 'Given permissions' do
  #  it "Should all permissions" do

  #    Db::Helper.permission
  #    get :index

  #    expect(response.status).to eql(200)
  #    expect(JSON.parse(response.body)).not_to eql([])
  #  end
  # end

  describe 'Given a request to show api' do
    it 'Should return permission' do
      permission = Db::Helper.permission
      get :show, params: { id: permission.id }

      expect(response.status).to eql(200)
      expect(JSON.parse(response.body).try(:[], 'name')).to eql(permission.name)
    end
  end

  after(:all) do
    Db::Helper.clean
  end
end
