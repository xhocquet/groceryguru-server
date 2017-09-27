require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "updating a receipt updates user's last_stats_update" do
    user = users(:admin)
    point_in_time = Time.now
    user.update(last_stats_update: point_in_time)
    assert_equal user.reload.last_stats_update, point_in_time
    user.receipts.first.update(text: "random!")
    refute_equal user.reload.last_stats_update, point_in_time
  end

  test "updating a transaction updates user's last_stats_update" do
    user = users(:admin)
    point_in_time = Time.now
    user.update(last_stats_update: point_in_time)
    assert_equal user.reload.last_stats_update, point_in_time
    user.transactions.first.update(raw: "random!")
    refute_equal user.reload.last_stats_update, point_in_time
  end
end
