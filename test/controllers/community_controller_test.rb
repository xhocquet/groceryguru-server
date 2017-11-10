require 'test_helper'

class CommunityControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:user)
  end

  test 'gets index' do
    get community_path
    assert_response :success
  end

  test 'renders new item submission' do
    get community_new_item_path
    assert_response :success
  end

  test 'creates item submission' do
    assert_difference 'Submission.count', 2 do
      post community_create_item_path params: { item_submission: { value: 'TestItem' } }
      assert_redirected_to community_new_item_path
    end
  end

  test 'renders new store submission' do
    get community_new_store_path
    assert_response :success
  end

  test 'creates store submission' do
    assert_difference 'Submission.count', 1 do
      post community_create_store_path params: { submission: { value: 'Test Store' } }
      assert_redirected_to community_new_store_path
    end
  end
end