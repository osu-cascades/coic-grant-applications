require "application_system_test_case"

class QueriesTest < ApplicationSystemTestCase
  setup do
    @query = queries(:one)

    get '/users/sign_in'
    sign_in users(:admin)
    post user_session_url
  end

  test "visiting the index" do
    visit queries_url
    assert_selector "h1", text: "Queries"
  end

  test "creating a Query" do
    visit queries_url
    click_on "New Query"

    click_on "Create Query"

    assert_text "Query was successfully created"
    click_on "Back"
  end

end
