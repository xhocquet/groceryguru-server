module StatsHelper
  def transaction_group_label(transaction_group)
    case transaction_group
    when 'improvable-transactions'
      return "We need more info for these items"
    when 'best-transactions'
      return "You're doing great on these items"
    when 'worst-transactions'
      return "You can save money on these items"
    end
  end

  def transaction_summary(transaction, best_ppu, worst_ppu)
    if best_ppu && transaction.price_per_unit == best_ppu
      summary = content_tag(:i, "check_circle", class: "material-icons")
      summary += content_tag(:h2, "You saved up to $#{transaction_saved(transaction, worst_ppu)} on your last purchase", class: "title")
    elsif worst_ppu && transaction.price_per_unit == worst_ppu
      summary = content_tag(:i, "error", class: "material-icons")
      summary += content_tag(:h2, "You lost $#{transaction_loss(transaction, best_ppu)} on your last purchase", class: 'title')
    else
      summary = content_tag(:i, "help", class: "material-icons")
      if best_ppu
        summary += content_tag(:h2, "You could have saved $#{transaction_loss(transaction, best_ppu)} more on your last purchase", class: 'title')
      end
    end
    return summary
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

  def transaction_row_class(transaction, best_ppu, worst_ppu)
    if transaction.price_per_unit == best_ppu
      'is-best'
    elsif transaction.price_per_unit == worst_ppu
      'is-worst'
    end
  end

  def container_class(transaction_group)
    case transaction_group
    when 'worst-transactions'
      return 'is-worst'
    when 'best-transactions'
      return 'is-best'
    end
  end
end
