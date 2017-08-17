class AddCompletedBoolToReceipts < ActiveRecord::Migration[5.1]
  def change
    add_column :receipts, :completed, :boolean, default: false
  end
end
