class DropModes < ActiveRecord::Migration[5.1]
  def change
    drop_table :item_modes
    remove_index :items, :mode_id
    remove_index :items,  column: [:name, :mode_id]
    remove_column :items, :mode_id
  end
end
