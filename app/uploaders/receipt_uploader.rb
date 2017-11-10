class ReceiptUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :file
  process :clean_image

  def store_dir
    if Rails.env.production?
      "public/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    else
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
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
      img.auto_orient!
      img.format = "png"
      img.crop!(model.image_crop_x.to_i,model.image_crop_y.to_i,model.image_crop_w.to_i,model.image_crop_h.to_i) if model.image_crop_y.present?
    end
  end
end
