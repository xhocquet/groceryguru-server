require 'test_helper'

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:admin)
  end

  test "should create transaction" do
    post receipt_transactions_path(Receipt.first), params: { transaction: { count: 2, name: "Apples" } }
    assert flash[:notice], 'Transaction created'
  end

  test "should update transaction" do
    patch transaction_path(Transaction.first), params: { transaction: { name: "Apple" } }
    assert flash[:notice], 'Transaction updated'
  end

  test "should destroy transaction" do
    assert_difference('Transaction.count', -1) do
      delete transaction_path(Transaction.first)
      assert flash[:notice], 'Transaction destroyed'
      end
  end
end