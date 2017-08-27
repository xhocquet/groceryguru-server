class ClearPricePerUnitCol < ActiveRecord::Migration[5.1]
  def change
    remove_column :transactions, :price_per_unit
  end
end
