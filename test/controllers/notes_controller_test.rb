require 'test_helper'

class NotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    get '/users/sign_in'
    sign_in users(:admin)
    post user_session_url

    @note = notes(:one)
    @company = companies(:one)
  end

  test "should get index" do
    get notes_url
    assert_response :success
  end

  test "should get show" do
    get notes_url(@note)
    assert_response :success
  end

  test "should get edit" do
    get edit_note_path(@note)
    assert_response :success
  end

  test "should get new" do
    get new_note_path(id: @company.id)
    assert_response :success
  end

end
