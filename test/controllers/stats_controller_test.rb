require 'test_helper'

class StatsControllerTest < ActionDispatch::IntegrationTest
  test "should get stats index" do
    sign_in users(:admin)
    get stats_path
    assert_response :success
  end
end