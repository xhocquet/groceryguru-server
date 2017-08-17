class StatsController < ApplicationController
  def index
    @transaction_groups = current_user.transactions.completed.group_by(&:item_id)
  end
end