class ReceiptUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :file
  process :clean_image

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def filename
    super.chomp(File.extname(super)) + '.png' if original_filename.present?
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  def content_type_whitelist
    /image\//
  end

  def clean_image
    manipulate! do |img|
      img.format = "png"
      img.resize! 2.25
      img.auto_level_channel
      img.deskew
      img.sharpen
      img.contrast
    end
  end
end
