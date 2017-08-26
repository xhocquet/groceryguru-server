class Receipt < ApplicationRecord
  include Parsers

  # Attachments
  mount_uploader :image, ReceiptUploader
  mount_uploader :pdf, ReceiptPDFUploader
  attr_accessor :image_cache, :image_crop_x, :image_crop_y, :image_crop_h, :image_crop_w

  belongs_to :user, inverse_of: :receipts
  belongs_to :store, required: false, inverse_of: :receipts
  has_many :items
  has_many :transactions, inverse_of: :receipt, dependent: :destroy

  after_create :process_text
  after_commit :update_metadata

  scope :completed, -> { where(completed: true) }
  scope :incomplete, -> { where(completed: false) }

  def lines
    self.text.present? ? self.text.split("\n") : []
  end

  private

  def process_text
    return if self.processed || self.image.blank?

    tesseract_image = RTesseract.new(self.image.path, psm: 4)
    self.pdf = File.open(tesseract_image.to_pdf)
    self.text = tesseract_image.to_s.downcase
    self.line_count = self.text.split("\n").size

    if self.store.present? && "Parsers::#{self.store.name.titleize}".safe_constantize
      "Parsers::#{self.store.name.titleize}".constantize.new(self).process
    else
      Parsers::Base.new(self).process
    end

    self.processed = true
    self.save!
  end

  def update_metadata
    self.user.update(last_stats_update: Time.now)
    return if self.destroyed?
    complete = self.transactions.incomplete.size == 0
    self.update_column(:completed, complete)
  end
end
