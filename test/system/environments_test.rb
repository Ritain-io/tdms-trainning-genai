# frozen_string_literal: true

require 'application_system_test_case'

class EnvironsTest < ApplicationSystemTestCase
  setup do
    @environ = environments(:one)
  end

  test 'visiting the index' do
    visit environments_url
    assert_selector 'h1', text: 'Environs'
  end

  test 'creating a Environment' do
    visit environments_url
    click_on 'New Environment'

    fill_in 'Name', with: @environ.name
    fill_in 'Sr Url', with: @environ.sr_url
    click_on 'Create Environment'

    assert_text 'Environment was successfully created'
    click_on 'Back'
  end

  test 'updating a Environment' do
    visit environments_url
    click_on 'Edit', match: :first

    fill_in 'Name', with: @environ.name
    fill_in 'Sr Url', with: @environ.sr_url
    click_on 'Update Environment'

    assert_text 'Environment was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Environment' do
    visit environments_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Environment was successfully destroyed'
  end
end
