class AddPdfToReceipts < ActiveRecord::Migration[5.1]
  def change
    add_column :receipts, :pdf, :string
  end
end
