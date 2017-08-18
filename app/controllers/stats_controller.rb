class StatsController < ApplicationController
  def index
    @transaction_groups = current_user.transactions.includes(:receipt, item: [:mode]).completed.group_by(&:item_id)
  end
end