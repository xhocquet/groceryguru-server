class Transaction < ApplicationRecord
  belongs_to :user, inverse_of: :transactions
  belongs_to :receipt, inverse_of: :transactions
  belongs_to :item, optional: true

  monetize :price_cents , allow_nil: true

  scope :completed, -> { where.not(name: nil).where.not(price_cents: nil).where('weight IS NOT NULL OR count IS NOT NULL') }

  after_commit :update_metadata, on: [:create, :update]

  def complete?
    return false if price.blank?
    return false if weight.blank? && count.blank?
    return false if name.blank?
    return true
  end

  def price_per_unit
    return self[:price_per_unit] if self[:price_per_unit].present?
    return nil if self.price.blank?
    if self.weight.present?
      unit = Unit.new(self.weight)
      unit >>= 'kg'
      value = (self.price.to_f/unit.scalar.to_f).round(2)
      value.infinite? ? nil : value
    elsif self.count.present?
      value = (self.price.to_f/self.count.to_f).round(2)
      value.infinite? ? nil : value
    else
      nil
    end
  end

  private

  def update_metadata
    self.update_column(:name, self.item.name) if self.item.present?
    self.update_column(:price_per_unit, self.price_per_unit) if self.price_per_unit.present?
  end
end
