require 'test_helper'

class TransactionTest < ActiveSupport::TestCase
  test 'completed scope returns accurately' do
    assert_equal Transaction.completed.count, 5
  end
end
