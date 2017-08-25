module TransactionHelper
  def display_price_per_unit(transaction)
    return "N/A" if transaction.price.blank?
    if transaction.weight.present?
      "$#{'%.2f' % transaction.price_per_unit}/kg"
    elsif transaction.count.present?
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
    diff = recent_transaction.price_per_unit - best_ppu
    if recent_transaction.count.present?
      (diff * recent_transaction.count).round(2)
    elsif recent_transaction.weight.present?
      case Unit.new(recent_transaction.weight).kind
      when :volume
        (diff * (Unit.new(recent_transaction.weight).convert_to('l').scalar.to_f.round(2))).round(2)
      when :mass
        (diff * (Unit.new(recent_transaction.weight).convert_to('kg').scalar.to_f.round(2))).round(2)
      end
    else
      nil
    end
  end

  def transaction_saved(recent_transaction, worst_ppu)
    diff = worst_ppu - recent_transaction.price_per_unit
    if recent_transaction.count.present?
      (diff * recent_transaction.count).round(2)
    elsif recent_transaction.weight.present?
      (diff * (Unit.new(recent_transaction.weight).convert_to('kg').scalar.to_f.round(2))).round(2)
    else
      nil
    end
  end

  def n_days_ago(transaction)
    "Last bought #{time_ago_in_words(transaction.created_at.to_date)} ago"
  end
end