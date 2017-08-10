class AddItemToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_reference :transactions, :item
  end
end
