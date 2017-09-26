require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "should get admin index" do
    sign_in users(:admin)
    get admin_path
    assert_response :success
  end

  test "should not be able to access admin" do
    sign_in users(:user)
    get admin_path
    assert_redirected_to new_user_session_url
  end

  test "item submissions should render for admin" do
    sign_in users(:admin)
    get admin_items_submissions_path
    assert_response :success
  end

  test "item submissions should not render for a non admin" do
    sign_in users(:user)
    get admin_items_submissions_path
    assert_redirected_to new_user_session_url
  end

  test "store submissions should render for admin" do
    sign_in users(:admin)
    get admin_stores_submissions_path
    assert_response :success
  end

  test "store submissions should not render for a non admin" do
    sign_in users(:user)
    get admin_stores_submissions_path
    assert_redirected_to new_user_session_url
  end
end