class AddUserToReceipts < ActiveRecord::Migration[5.1]
  def change
    add_reference :receipts, :user, foreign_key: true
  end
end
