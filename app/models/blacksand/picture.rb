module Blacksand
  class Picture < ActiveRecord::Base
    mount_uploader :file, ImageUploader

    belongs_to :imageable, polymorphic: true
  end
end
