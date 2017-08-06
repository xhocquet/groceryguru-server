class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable

  has_many :receipts, dependent: :destroy, inverse_of: :user
  has_many :transactions, dependent: :destroy, inverse_of: :user
end
