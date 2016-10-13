module Blacksand
  class BaseUploader < CarrierWave::Uploader::Base
    include CarrierWave::MiniMagick

    set_storage_from_config

    # TODO: config store_dir prefix
    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end
end