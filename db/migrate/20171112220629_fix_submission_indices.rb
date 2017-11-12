class FixSubmissionIndices < ActiveRecord::Migration[5.1]
  def change
    remove_index :stores, :name
    add_index :stores, [:name, :postal_code], unique: true
  end
end
