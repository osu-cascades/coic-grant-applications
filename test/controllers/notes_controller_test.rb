require 'test_helper'

class NotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    get '/users/sign_in'
    sign_in users(:admin)
    post user_session_url
  end

  test "should get index" do
    get notes_index_url
    assert_response :success
  end

  test "should get show" do
    get notes_show_url
    assert_response :success
  end

  test "should get edit" do
    get notes_edit_url
    assert_response :success
  end

  test "should get new" do
    get notes_new_url
    assert_response :success
  end

end
