class AddUserToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_reference :transactions, :user, foreign_key: true
  end
end
