class User < ApplicationRecord
  acts_as_token_authenticatable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :receipts, dependent: :destroy, inverse_of: :user
  has_many :transactions, dependent: :destroy, inverse_of: :user
  has_many :submissions, dependent: :destroy, inverse_of: :user

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.skip_confirmation!
    end
  end
end
