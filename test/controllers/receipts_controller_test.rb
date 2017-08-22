require 'test_helper'

class ReceiptsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:admin)
  end

  test "should get receipt index" do
    get receipts_path
    assert_response :success
  end

  test "should create receipt" do
    assert_difference('Receipt.count', 1) do
      post receipts_path, params: { receipt: { image: Faker::Avatar.image } }
      assert_redirected_to receipt_path(Receipt.last)
    end
  end

  test "should show receipt" do
    get receipt_path(Receipt.first)
    assert_response :success
  end

  test "should updated receipt" do
    patch receipt_path(Receipt.first), params: { receipt: { store_id: Store.first.id } }
    assert flash[:notice], 'Receipt updated'
  end

  test "should destroy receipt" do
    assert_difference('Receipt.count', -1) do
      delete receipt_path(Receipt.first)
      assert flash[:notice], 'Receipt deleted'
    end
  end
end