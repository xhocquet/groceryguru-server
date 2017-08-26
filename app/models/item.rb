class Item < ApplicationRecord
  has_many :receipts
  has_one :receipt_transaction, class_name: "Transaction"
  belongs_to :mode
  belongs_to :group

  def self.search(query = nil)
    if query
      items = Item.arel_table
      Item.where(items[:name].matches("%#{query}%")).order("LENGTH(items.name) ASC").limit(6)
    else
      Item.limit(6)
    end
  end
end
