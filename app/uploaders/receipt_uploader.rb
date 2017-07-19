class ReceiptUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :file
  process :clean_image

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  def content_type_whitelist
    /image\//
  end

  def clean_image
    manipulate! do |img|
      img.resize! 3.5
      img.deskew
    end
  end
end
