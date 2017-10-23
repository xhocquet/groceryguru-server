class User < ApplicationRecord
  acts_as_token_authenticatable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :receipts, dependent: :destroy, inverse_of: :user
  has_many :transactions, dependent: :destroy, inverse_of: :user
  has_many :submissions, dependent: :destroy, inverse_of: :user

  def self.from_omniauth(auth)
    data = access_token.info
    user = User.where(email: data['email']).first

    # Uncomment the section below if you want users to be created if they don't exist
    unless user
        user = User.create(name: data['name'],
           email: data['email'],
           password: Devise.friendly_token[0,20]
        )
    end
    user.skip_confirmation!
    user
  end
end
