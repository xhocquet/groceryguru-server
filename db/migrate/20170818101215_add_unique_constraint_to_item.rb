class AddUniqueConstraintToItem < ActiveRecord::Migration[5.1]
  def change
    add_index :items, [:name, :mode_id], unique: true
  end
end
