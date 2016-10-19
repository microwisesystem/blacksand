module Blacksand
  class Property::File < Property
    mount_uploader :file, Blacksand::FileUploader
  end
end