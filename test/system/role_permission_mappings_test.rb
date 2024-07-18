# frozen_string_literal: true

require 'application_system_test_case'

class RolePermissionMappingsTest < ApplicationSystemTestCase
  setup do
    @role_permission_mapping = role_permission_mappings(:one)
  end

  test 'visiting the index' do
    visit role_permission_mappings_url
    assert_selector 'h1', text: 'Role Permission Mappings'
  end

  test 'creating a Role permission mapping' do
    visit role_permission_mappings_url
    click_on 'New Role Permission Mapping'

    click_on 'Create Role permission mapping'

    assert_text 'Role permission mapping was successfully created'
    click_on 'Back'
  end

  test 'updating a Role permission mapping' do
    visit role_permission_mappings_url
    click_on 'Edit', match: :first

    click_on 'Update Role permission mapping'

    assert_text 'Role permission mapping was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Role permission mapping' do
    visit role_permission_mappings_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Role permission mapping was successfully destroyed'
  end
end
