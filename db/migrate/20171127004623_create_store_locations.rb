class CreateStoreLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :store_locations do |t|
      t.string :postal_code
      t.references :store
    end
  end
end
