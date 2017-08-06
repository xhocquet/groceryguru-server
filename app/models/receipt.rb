class Receipt < ApplicationRecord
  # Attachments
  mount_uploader :image, ReceiptUploader
  mount_uploader :pdf, ReceiptPDFUploader
  attr_accessor :image_cache

  belongs_to :user, inverse_of: :receipts
  belongs_to :store, required: false, inverse_of: :receipts
  has_many :items
  has_many :transactions, inverse_of: :receipt, dependent: :destroy

  def lines
    text.present? ? text.split("\n") : []
  end
end
