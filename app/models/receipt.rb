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
    text.present? ? text.split("\n") : []
  end

  # Fallback date to created_at
  def date
    self[:date] || self.created_at
  end

  private

  def process_text
    return if self.processed
    return if self.image.blank?

    tesseract_image = RTesseract.new(self.image.path, psm: 4)
    self.pdf = File.open(tesseract_image.to_pdf)
    self.text = tesseract_image.to_s.downcase

    self.line_count = self.text.split("\n").size

    self.text.split("\n").each_with_index do |line, index|
      next if line.strip.blank?

      # Check first 6 lines for store name
      if index < 6 && self.store.blank? && line.downcase.match(/([\w\']{2,})/)
        line.downcase.match(/([\w\']{2,})/).captures.each do |string|
          self.store = Store.find_by_name(string)
        end
      end

      break if index > 5 || self.store.present?
    end

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
