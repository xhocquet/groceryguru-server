require 'test_helper'

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:admin)
  end

  test "should create transaction" do
    assert_difference("Transaction.count", 1) do
      post receipt_transactions_path(Receipt.first), params: { transaction: { count: 2, name: "Apples" } }
    end
  end

  test "should update transaction" do
    transaction = users(:admin).transactions.first
    patch transaction_path(transaction), params: { transaction: { name: "Apple" } }
    assert_equal "Apple", transaction.reload.name
  end

  test "should destroy transaction" do
    assert_difference("Transaction.count", -1) do
      delete transaction_path(users(:admin).transactions.first)
    end
  end
end