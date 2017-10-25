class AddBoundingBoxDataToReceipts < ActiveRecord::Migration[5.1]
  def change
    add_column :receipts, :box_data, :text
  end
end
