class AddPricePerUnitToTransaction < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :price_per_unit, :float
  end
end
