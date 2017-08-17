class AddStatsTimestampToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :last_stats_update, :timestamp
  end
end
