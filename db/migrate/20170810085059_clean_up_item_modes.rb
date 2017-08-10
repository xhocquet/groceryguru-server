class CleanUpItemModes < ActiveRecord::Migration[5.1]
  def change
    drop_table :items_item_modes

    add_reference :items, :mode
  end
end
