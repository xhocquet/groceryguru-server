module TransactionHelper
  def display_price_per_unit(transaction)
    if transaction.weight.present? && transaction.price_per_unit
      "$#{'%.2f' % transaction.price_per_unit}/kg"
    elsif transaction.count.present? && transaction.price_per_unit
      "$#{'%.2f' % transaction.price_per_unit}"
    else
      "N/A"
    end
  end

  def weight_diff_math(weight, diff)
    case Unit.new(weight).kind
    when :volume
      (diff * (Unit.new(weight).convert_to('l').scalar.to_f))
    when :mass
      (diff * (Unit.new(weight).convert_to('kg').scalar.to_f))
    end
  end

  def n_days_ago(transaction)
    "Last bought #{time_ago_in_words(transaction.created_at.to_date)} ago"
  end
end