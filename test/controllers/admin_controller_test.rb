require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "should get admin index" do
    sign_in users(:admin)
    get admin_path
    assert_response :success
  end
end