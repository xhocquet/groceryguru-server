class Transaction < ApplicationRecord
  belongs_to :user, inverse_of: :transactions
  belongs_to :receipt, inverse_of: :transactions
  belongs_to :item, optional: true

  monetize :price_cents , allow_nil: true

  default_scope { order(line_number: :asc, created_at: :desc) }
  scope :completed, -> { where.not(name: nil).where.not(price_cents: nil).where('weight IS NOT NULL OR count IS NOT NULL') }
  scope :incomplete, -> { where("name IS NULL OR price_cents IS NULL OR (weight IS NULL AND count IS NULL)") }

  after_commit :update_metadata, on: [:create, :update]
  after_commit :touch_receipt

  def complete?
    return false if price.blank?
    return false if weight.blank? && count.blank?
    return false if name.blank?
    return true
  end

  def price_per_unit
    return nil if self.price.blank?
    if self.weight.present?
      unit = Unit.new(self.weight)
      case unit.kind
      when :volume
        unit >>= 'l'
      when :mass
        unit >>= 'kg'
      end
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

  def touch_receipt
    self.receipt.update(updated_at: Time.now) unless self.receipt.destroyed?
  end

  def update_metadata
    self.update_column(:name, self.item.name) if self.item.present?
  end
end
