class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :receipt, inverse_of: :transactions

  monetize :price_cents 
  measured_weight :weight

  scope :completed, -> { where.not(name: nil).where.not(price_cents: nil).where('(weight_value AND weight_unit IS NOT NULL) OR count IS NOT NULL') }

  def complete?
    return false if price.blank?
    return false if (weight_value.blank? || weight_unit.blank?) && count.blank?
    return false if name.blank?
    return true
  end
end
