class Receipt < ApplicationRecord
  # Attachments
  mount_uploader :image, ReceiptUploader
  mount_uploader :pdf, ReceiptPDFUploader
  attr_accessor :image_cache

  belongs_to :user
  belongs_to :store, required: false
  has_many :items
  has_many :transactions, inverse_of: :receipt, dependent: :destroy
end
