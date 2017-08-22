require 'test_helper'

class ItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:admin)
  end

  test "should get admin item index" do
    get admin_items_path
    assert_response :success
  end

  test "should get admin item index with alpha param" do
    get admin_items_path(alpha: 'z')
    assert_response :success
  end

  test "should destroy item as admin" do
    banana = items(:banana)
    assert_difference('Item.count', -1) do
      delete admin_item_path(banana)
      assert flash[:notice], 'Item destroyed'
    end
  end

  test "search should return results" do
    get api_item_search_path(query: 'banana')
    assert_response :success
    assert_match 'banana', @response.body
  end
end