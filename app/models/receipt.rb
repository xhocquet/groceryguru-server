class Receipt < ApplicationRecord
  include Parsers

  # Attachments
  mount_uploader :image, ReceiptUploader
  mount_uploader :pdf, ReceiptPDFUploader
  attr_accessor :image_cache

  belongs_to :user, inverse_of: :receipts
  belongs_to :store, required: false, inverse_of: :receipts
  has_many :items
  has_many :transactions, inverse_of: :receipt, dependent: :destroy

  after_create :process_text

  def lines
    text.present? ? text.split("\n") : []
  end

  private

  def process_text
    return if self.processed

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

    if self.store.present? && "Parsers::#{self.store.name.titleize}".constantize.present?
      "Parsers::#{self.store.name.titleize}".constantize.new(self).process
    else
      Parsers::Base.new(self).process
    end

    self.processed = true
    self.save!
  end
end
