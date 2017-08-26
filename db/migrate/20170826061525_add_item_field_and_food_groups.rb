class AddItemFieldAndFoodGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :usda_id, :integer
    create_table :item_groups do |t|
      t.string :name
      t.integer :usda_id
      t.timestamps
    end
    add_reference :items, :group
  end
end
