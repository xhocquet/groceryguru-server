class CreateItemModes < ActiveRecord::Migration[5.1]
  def change
    create_table :item_modes do |t|
      t.string :name
      t.timestamps
    end
  end
end
