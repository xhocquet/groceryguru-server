class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :receipt, inverse_of: :transactions

  monetize :price_cents 
  measured_weight :weight

  scope :incomplete, -> (x) { x.complete? }

  validates :weight_value, numericality: true, allow_nil: true
  validates :count, numericality: true, allow_nil: true
  validates :price, numericality: true, allow_nil: true


  def self.complete?
    return false if price.blank?
    return false if weight.blank? && count.blank?
    return true
  end
end
