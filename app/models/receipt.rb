class Receipt < ApplicationRecord
  paginates_per 15

  # Attachments
  mount_uploader :image, ReceiptUploader
  mount_uploader :pdf, ReceiptPDFUploader
  attr_accessor :image_cache, :image_crop_x, :image_crop_y, :image_crop_h, :image_crop_w
  serialize :box_data, Array

  belongs_to :user, inverse_of: :receipts
  belongs_to :store, required: false, inverse_of: :receipts, class_name: 'Store::Location'
  has_many :items
  has_many :transactions, inverse_of: :receipt, dependent: :destroy

  after_create :process_text
  after_commit :update_metadata

  scope :completed, -> { where(completed: true) }
  scope :incomplete, -> { where(completed: false) }

  def lines
    self.text.present? ? self.text.split("\n") : []
  end

  def display_date
    self.date.present? ? self.date : self.created_at
  end

  private

  # Before can background, need external storage for images
  def process_text
    return if self.processed || self.image.blank?

    tesseract_image = RTesseract.new(self.image.path, psm: 4)
    self.box_data = RTesseract::Box.new(self.image.path, psm: 4).words
    self.pdf = File.open(tesseract_image.to_pdf) if File.exist?(tesseract_image.to_pdf)
    self.text = tesseract_image.to_s.downcase
    self.line_count = self.text.split("\n").size

    ReceiptParser.new(self).process

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
