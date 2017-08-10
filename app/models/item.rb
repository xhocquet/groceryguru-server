class Item < ApplicationRecord
  has_many :receipts

  belongs_to :mode
  
  has_one :receipt_transaction, class_name: "Transaction"

  def self.search(query = nil)
    if query
      items = Item.arel_table
      Item.where(items[:name].matches("%#{query}%")).limit(6)
    else
      Item.first(6)
    end
  end
end
