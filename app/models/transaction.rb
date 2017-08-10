class Transaction < ApplicationRecord
  belongs_to :user, inverse_of: :transactions
  belongs_to :receipt, inverse_of: :transactions

  belongs_to :item, optional: true

  monetize :price_cents , allow_nil: true
  measured_weight :weight

  scope :completed, -> { where.not(name: nil).where.not(price_cents: nil).where('(weight_value IS NOT NULL AND weight_unit IS NOT NULL) OR count IS NOT NULL') }

  def complete?
    return false if price.blank?
    return false if (weight_value.blank? || weight_unit.blank?) && count.blank?
    return false if name.blank?
    return true
  end

  def name
    if self.item.present? 
      return self.item.name 
    else 
      return self[:name] 
    end
  end
end
