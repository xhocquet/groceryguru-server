class CreateCouponsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :coupons do |t|
      t.timestamp :expiration_date
      t.timestamp :store_begin_date
      t.string :title
      t.string :image_url
      t.string :requirements
      t.string :description
      t.integer :type, default: 0
      t.integer :status, default: 1
      t.references :store, required: true
      t.references :item, required: false
    end
  end
end
