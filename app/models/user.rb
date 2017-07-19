class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable

  has_many :receipts, dependent: :destroy
  has_many :transactions, dependent: :destroy
end
