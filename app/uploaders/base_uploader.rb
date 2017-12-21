class BaseUploader < CarrierWave::Uploader::Base
  def store_dir
    if Rails.env.production?
      "public/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    else
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end
end
