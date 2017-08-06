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
    dpi_string =  `identify -format "%x-%y" #{current_path}`
    x,y = dpi_string.split('-')
    puts "X-Y DPI not equal" unless x == y
    resize_ratio = (300/x.to_f).round(2)
    
    manipulate! do |img|
      debugger
      img.auto_orient!
      img.format = "png"
      img.auto_level_channel
      img.deskew
      img.sharpen
      img.contrast
      img.resize! resize_ratio
    end
  end
end
