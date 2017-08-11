class Item < ApplicationRecord
  has_many :receipts
  has_one :receipt_transaction, class_name: "Transaction"
  belongs_to :mode
  
  def self.search(query = nil)
    if query
      items = Item.arel_table
      Item.where(items[:name].matches("%#{query}%")).limit(6)
    else
      Item.first(6)
    end
  end
end
