require "application_system_test_case"

class QueriesTest < ApplicationSystemTestCase
  setup do
    @query = queries(:one)

    visit '/users/sign_in'
    sign_in users(:admin)
    visit user_session_url
  end

  test "visiting the index" do
    visit root_path
    #0% with no uploads in applicants in database
    assert_selector "h3", text: "Percentage of Applicants: 0%"
  end

  test "creating a Query" do
    visit queries_url
    click_on "New Query"

    click_on "Create Query"

    assert_text "Query was successfully created"
    click_on "Back"
  end

end
