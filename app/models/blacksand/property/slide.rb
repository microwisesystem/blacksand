module Blacksand
  class Property::Slide < Property
    mount_uploader :image, Blacksand::SlideImageUploader
  end
end