class Transaction < ApplicationRecord
  belongs_to :user, inverse_of: :transactions
  belongs_to :receipt, inverse_of: :transactions
  belongs_to :item, optional: true

  monetize :price_cents , allow_nil: true

  scope :completed, -> { where.not(name: nil).where.not(price_cents: nil).where('weight IS NOT NULL OR count IS NOT NULL') }

  def complete?
    return false if price.blank?
    return false if weight.blank? && count.blank?
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

  def price_per_unit
    return nil if self.price.blank?
    if self.weight.present?
      unit = Unit.new(self.weight)
      unit >>= 'kg'
      (self.price.to_f/unit.scalar.to_f).round(2)
    elsif self.count.present?
      (self.price/self.count).round(2)
    else
      nil
    end
  end
end
