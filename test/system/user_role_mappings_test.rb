# frozen_string_literal: true

require 'application_system_test_case'

class UserRoleMappingsTest < ApplicationSystemTestCase
  setup do
    @user_role_mapping = user_role_mappings(:one)
  end

  test 'visiting the index' do
    visit user_role_mappings_url
    assert_selector 'h1', text: 'User Role Mappings'
  end

  test 'creating a User role mapping' do
    visit user_role_mappings_url
    click_on 'New User Role Mapping'

    click_on 'Create User role mapping'

    assert_text 'User role mapping was successfully created'
    click_on 'Back'
  end

  test 'updating a User role mapping' do
    visit user_role_mappings_url
    click_on 'Edit', match: :first

    click_on 'Update User role mapping'

    assert_text 'User role mapping was successfully updated'
    click_on 'Back'
  end

  test 'destroying a User role mapping' do
    visit user_role_mappings_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'User role mapping was successfully destroyed'
  end
end
