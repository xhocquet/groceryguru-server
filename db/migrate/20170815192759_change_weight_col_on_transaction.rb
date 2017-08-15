class ChangeWeightColOnTransaction < ActiveRecord::Migration[5.1]
  def change
    remove_column :transactions, :weight_value
    remove_column :transactions, :weight_unit
    add_column :transactions, :weight, :text
  end
end
