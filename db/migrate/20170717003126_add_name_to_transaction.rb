class AddNameToTransaction < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :name, :text, null: true
  end
end
