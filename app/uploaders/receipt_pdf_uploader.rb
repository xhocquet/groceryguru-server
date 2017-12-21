class ReceiptPDFUploader < BaseUploader
  storage :file

  def extension_whitelist
    %w(pdf)
  end
end
