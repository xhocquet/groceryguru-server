class Coupon < ApplicationRecord
  belongs_to :store, required: true, inverse_of: :coupons, class_name: 'Store::Location'

  enum status: {
    upcoming: 0,
    active: 1,
    expired: 2,
  }

  enum type: {
    discount: 0,
    n_for_x_deal: 1,
    x_off_n_deal: 2,
    buy_n_get_n: 3,
  }


end