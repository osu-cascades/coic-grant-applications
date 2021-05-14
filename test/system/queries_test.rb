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

  test "run a Query for gender" do
    visit root_path

    check "Female"
    click_on "Submit Query"

    assert_selector "h3", text: "Percentage of Applicants: 60.92%"
    assert_selector "h3", text: "Number of Awards: 53"
    assert_selector "h3", text: "Amount Awarded: $151,074.28"

    visit root_path

    check "Male"
    click_on "Submit Query"

    assert_selector "h3", text: "Percentage of Applicants: 39.08%"
    assert_selector "h3", text: "Number of Awards: 34"
    assert_selector "h3", text: "Amount Awarded: $95,616.14"   
  end

  test "run a Query for race" do
    visit root_path

    check "American Indian or Alaska Native"
    click_on "Submit Query"

    assert_selector "h3", text: "Percentage of Applicants: 5.75%"
    assert_selector "h3", text: "Number of Awards: 5"
    assert_selector "h3", text: "Amount Awarded: $12,500.0"

    visit root_path

    check "Asian"
    click_on "Submit Query"

    assert_selector "h3", text: "Percentage of Applicants: 1.15%"
    assert_selector "h3", text: "Number of Awards: 1"
    assert_selector "h3", text: "Amount Awarded: $2,500.0"   
  end
end
