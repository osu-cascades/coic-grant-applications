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

  test "run a Query" do
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

end
