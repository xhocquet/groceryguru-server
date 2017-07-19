class AddStoreToReceipts < ActiveRecord::Migration[5.1]
  def change
    add_reference :receipts, :store, foreign_key: true
  end
end
