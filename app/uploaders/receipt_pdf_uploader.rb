class ReceiptPDFUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "public/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(pdf)
  end
end
