class Receipt < ApplicationRecord
  mount_uploader :image, ReceiptUploader
  mount_uploader :pdf, ReceiptPDFUploader
  attr_accessor :image_cache

  belongs_to :user
end
