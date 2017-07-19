class CreateStores < ActiveRecord::Migration[5.1]
  def change
    create_table :stores do |t|
      t.integer :postal_code
      t.text :name

      t.timestamps
    end
  end
end
