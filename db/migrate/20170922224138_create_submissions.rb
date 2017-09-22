class CreateSubmissions < ActiveRecord::Migration[5.1]
  def change
    create_table :submissions do |t|
      t.string :model_type
      t.string :value
      t.references :user

      t.timestamps
    end
  end
end
