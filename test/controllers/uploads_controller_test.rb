require 'test_helper'

class UploadsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @upload = uploads(:one)

    get '/users/sign_in'
    sign_in users(:admin)
    post user_session_url
    
  end

  test "should get index" do
    get uploads_url
    assert_response :success
  end

  test "should get new" do
    get new_upload_url
    assert_response :success
  end

  test "should create upload" do
    assert_difference('Upload.count') do
      post uploads_url, params: { upload: { round: "test", data: file_fixture("test.csv").read } }
    end

    assert_redirected_to upload_url(Upload.last)
  end

  test "should show upload" do
    get upload_url(@upload)
    assert_response :success
  end

  test "should destroy upload" do
    assert_difference('Upload.count', -1) do
      delete upload_url(@upload)
    end

    assert_redirected_to uploads_url
  end
end
