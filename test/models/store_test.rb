require 'test_helper'

class StoreTest < ActiveSupport::TestCase
  test 'item name delegates to association if present' do
    t = Transaction.create! name: 'test', user: User.first, receipt: Receipt.first
    assert_equal t.name, 'test'
    t.update! item: Item.first
    assert_equal Item.first.name, t.name
  end
end
