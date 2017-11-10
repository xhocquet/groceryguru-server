require 'test_helper'

class Api::SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:admin)
  end

  test "should fail requests without a parameter" do
    post api_session_path params: { }, format: :json
    assert_response 422
  end

  test "should fail requests with invalid password" do
    post api_session_path params: { user_login: { email: @user.email, password: 'notpassword' }}, format: :json
    assert_response 401
  end

  test "should create session for valid request" do
    post api_session_path params: { user_login: { email: @user.email, password: 'password' }}, format: :json
    assert_response :success
    assert_equal JSON.parse(response.body)['auth_token'], @user.authentication_token
  end
end