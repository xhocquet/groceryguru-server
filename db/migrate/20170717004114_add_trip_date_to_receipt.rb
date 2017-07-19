class AddTripDateToReceipt < ActiveRecord::Migration[5.1]
  def change
    add_column :receipts, :date, :timestamp, null: true
  end
end
