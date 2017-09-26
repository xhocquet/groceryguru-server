require 'test_helper'

class CommunityControllerTest < ActionDispatch::IntegrationTest
  test 'gets index' do
    sign_in users(:admin)
    get community_path
    assert_response :success
  end
end