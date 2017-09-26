require 'test_helper'

class CommunityControllerTest < ActionDispatch::IntegrationTest
  test 'gets index' do
    sign_in users(:user)
    get community_path
    assert_response :success
  end
end