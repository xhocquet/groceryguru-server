class AddReceiptToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_reference :transactions, :receipt, foreign_key: true
  end
end
