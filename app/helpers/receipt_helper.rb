module ReceiptHelper
  def transactions_count(receipt)
    receipt.transactions.count
  end

  def completed_transactions_count(receipt)
    receipt.transactions.completed.count
  end
end
