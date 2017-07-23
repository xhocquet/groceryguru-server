class CreateItemModesTable < ActiveRecord::Migration[5.1]
  def change
    create_table :items_item_modes do |t|
      t.belongs_to :item, index: true
      t.belongs_to :item_mode, index: true
    end
  end
end
