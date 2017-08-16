module TransactionHelper
  def price_per_unit(transaction)
    return "N/A" if transaction.price.blank?
    if transaction.weight.present?
      "$#{transaction.price_per_unit}/kg"
    elsif transaction.count.present?
      "$#{transaction.price_per_unit}"
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

  def n_days_ago(transaction)
    time_ago_in_words(transaction.created_at.to_date) + ' ago'
  end
end