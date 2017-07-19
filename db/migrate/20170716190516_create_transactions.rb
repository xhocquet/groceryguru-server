class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.text :raw, allow_nil: true
      t.decimal :weight_value, allow_nil: true, precision: 10, scale: 2
      t.string :weight_unit, allow_nil: true, limit: 12
      t.integer :count, allow_nil: true
      t.monetize :price, amount: { null: true, default: nil }

      t.timestamps
    end
  end
end
