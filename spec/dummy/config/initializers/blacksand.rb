Blacksand.site_id   = 'dark'
Blacksand.site_name = 'test name'
Blacksand.root_path = 'root path'
Blacksand.carrierwave_storage = :qiniu # :qiniu


# Override versions or styles
Blacksand::ImageUploader.class_eval do
  qiniu_styles [:test, :test2]
end
