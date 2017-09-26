require 'test_helper'

class StoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:admin)
  end

  test "should get admin store index" do
    get admin_stores_path
    assert_response :success
  end

  test "should get admin store index with alpha param" do
    get admin_stores_path(alpha: 'z')
    assert_response :success
  end

  test "should destroy item as admin" do
    soopers = stores(:soopers)
    assert_difference('Store.count', -1) do
      delete admin_store_path(soopers)
      assert flash[:notice], 'Store destroyed'
    end
  end

  test "search should return results" do
    get api_store_search_path(query: 'soopers')
    assert_response :success
    assert_match 'Soopers', @response.body
  end

  test "store submissions should render for admin" do
    get admin_stores_submissions_path
    assert_response :success
  end
end