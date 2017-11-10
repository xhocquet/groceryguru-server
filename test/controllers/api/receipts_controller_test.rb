require 'test_helper'

class Api::ReceiptsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:admin)
  end

  test "index should render" do
    sign_in @user
    get api_receipts_path headers: { 'X-User-Email': @user.email, 'X-User-Token': @user.authentication_token }, format: :json
    assert_response :success
  end
end