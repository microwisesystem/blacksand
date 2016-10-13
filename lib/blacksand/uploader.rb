module Blacksand
  module Uploader

    # 设置 uploader 的 storage, 通过配置
    def set_storage_from_config
      storage Blacksand.carrierwave_storage
    end
  end
end

CarrierWave::Uploader::Base.extend(Blacksand::Uploader)