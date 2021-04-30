require 'test_helper'

class QueriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @query = queries(:one)

    get '/users/sign_in'
    sign_in users(:admin)
    post user_session_url
    
  end

  test "should show query" do
    get query_url(@query)
    assert_response :success
  end

end
