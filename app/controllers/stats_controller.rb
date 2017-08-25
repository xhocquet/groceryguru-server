class StatsController < ApplicationController
  def index
    @transaction_groups = current_user.transactions
                          .includes(:item, receipt: [:store])
                          .completed
                          .group_by(&:item_id)
                          .reject { |item_id, transactions|
                            transactions.pluck(:price_per_unit).compact.uniq.size < 2
                          }
                          .sort_by { |item_id, transactions|
                            best_ppu = transactions.pluck(:price_per_unit).compact.min
                            worst_ppu = transactions.pluck(:price_per_unit).compact.max
                            most_recent_transaction = transactions.sort_by{|t| t.receipt.date}.reverse.first

                            if most_recent_transaction.price_per_unit == best_ppu
                              1
                            elsif most_recent_transaction.price_per_unit == worst_ppu
                              -1
                            else
                              0
                            end
                          }
  end
end