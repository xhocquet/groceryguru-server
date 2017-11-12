class Store < ApplicationRecord
  has_many :receipts, inverse_of: :store
  belongs_to :submission, required: false

  def self.search(query = nil)
    if query
      stores = Store.arel_table
      Store.where(stores[:name].matches("%#{query}%")).limit(6)
    else
      Store.first(6)
    end
  end
end
