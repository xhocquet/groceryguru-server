require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    sign_in users(:admin)
    get root_path
    assert_response :success
  end
end