class StatsController < ApplicationController
  acts_as_token_authentication_handler_for User, if: lambda { |controller| controller.request.format.json? }

  def index
    @transaction_groups = current_user.transactions
                          .includes(:item, receipt: [:store])
                          .completed
                          .group_by(&:item_id)
                          .reject { |item_id, transactions|
                            (transactions.map(&:price_per_unit).compact.uniq.size < 2) || item_id.blank?
                          }.group_by { |_, transactions|
                            best_ppu = transactions.map(&:price_per_unit).compact.min
                            worst_ppu = transactions.map(&:price_per_unit).compact.max
                            most_recent_transaction = transactions.sort_by{|t| t.receipt.created_at}.reverse.first

                            if most_recent_transaction.price_per_unit == best_ppu
                              'best-transactions'
                            elsif most_recent_transaction.price_per_unit == worst_ppu
                              'worst-transactions'
                            else
                              'improvable-transactions'
                            end
                          }

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @transaction_groups.to_json }
    end
  end
end