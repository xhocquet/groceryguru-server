class Store < ApplicationRecord
  has_many :receipts, inverse_of: :store

  def self.fuzzy_search(term)
    Store.where("levenshtein(name, ?) <= 3", term.downcase)
  end
end
