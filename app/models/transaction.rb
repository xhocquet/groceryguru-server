class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :receipt, inverse_of: :transactions

  monetize :price_cents 
  measured_weight :weight

  validates :weight_value, numericality: true, allow_nil: true
  validates :count, numericality: true, allow_nil: true
  validates :price, numericality: true, allow_nil: true


  def complete?
    return false if price.blank?
    return false if weight.blank? && count.blank?
    return false if name.blank?
    return true
  end
end
