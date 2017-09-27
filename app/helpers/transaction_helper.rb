module TransactionHelper
  def display_price_per_unit(transaction)
    return "N/A" if transaction.price.blank?
    if transaction.weight.present? && transaction.price_per_unit.present?
      "$#{'%.2f' % transaction.price_per_unit}/kg"
    elsif transaction.count.present? && transaction.price_per_unit.present?
      "$#{'%.2f' % transaction.price_per_unit}"
    else
      "N/A"
    end
  end

  def transaction_row_class(transaction, best_ppu, worst_ppu)
    if transaction.price_per_unit == best_ppu
      'is-best'
    elsif transaction.price_per_unit == worst_ppu
      'is-worst'
    end
  end

  def transaction_loss(recent_transaction, best_ppu)
    return nil unless recent_transaction.price_per_unit.present?

    diff = recent_transaction.price_per_unit - best_ppu
    if recent_transaction.count.present?
      (diff * recent_transaction.count).round(2)
    elsif recent_transaction.weight.present?
      weight_diff_math(recent_transaction.weight, diff)
    else
      nil
    end
  end

  def transaction_saved(recent_transaction, worst_ppu)
    diff = worst_ppu - recent_transaction.price_per_unit
    if recent_transaction.count.present?
      (diff * recent_transaction.count).round(2)
    elsif recent_transaction.weight.present?
      weight_diff_math(recent_transaction.weight, diff)
    else
      nil
    end
  end

  def weight_diff_math(weight, diff)
    case Unit.new(weight).kind
    when :volume
      (diff * (Unit.new(weight).convert_to('l').scalar.to_f.round(2))).round(2)
    when :mass
      (diff * (Unit.new(weight).convert_to('kg').scalar.to_f.round(2))).round(2)
    end
  end

  def n_days_ago(transaction)
    "Last bought #{time_ago_in_words(transaction.created_at.to_date)} ago"
  end
end