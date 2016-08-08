module Blacksand
  class Property::Slide < Property
    mount_uploader :image, SlideImageUploader
  end
end