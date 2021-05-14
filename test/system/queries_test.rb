require "application_system_test_case"

class QueriesTest < ApplicationSystemTestCase
  setup do
    visit '/users/sign_in'
    sign_in users(:admin)
    visit user_session_url

    visit uploads_url
    click_on 'New Upload'
    fill_in 'Title', :with => 'New Test Upload'
    fill_in 'Round', :with => 'Round Test'
    attach_file('upload_data', 'test\fixtures\files\test_round.csv')

    click_on "Save"

    Application.destroy(applications(:one).id)
  end

  test "visiting the index" do
    visit root_path
    assert_selector "h3", text: "Percentage of Applicants: 100.0%"
  end

  test "creating a Query" do
    visit queries_url
    click_on "New Query"

    click_on "Create Query"

    assert_text "Query was successfully created"
    click_on "Back"
  end

end
