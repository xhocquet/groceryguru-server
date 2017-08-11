class AddLineCountToReceipts < ActiveRecord::Migration[5.1]
  def change
    add_column :receipts, :line_count, :integer, default: 0
    add_column :transactions, :line_number, :integer, default: nil, null: true
    add_column :receipts, :processed, :boolean, default: false
  end
end
