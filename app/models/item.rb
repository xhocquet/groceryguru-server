class Item < ApplicationRecord
  has_many :receipts
  has_and_belongs_to_many :modes
end
