module StatsHelper
  def transaction_class(most_recent_transaction, worst_ppu, best_ppu)
    if most_recent_transaction.price_per_unit == worst_ppu
      'is-worst'
    elsif most_recent_transaction.price_per_unit == best_ppu
      'is-best'
    end
  end
end