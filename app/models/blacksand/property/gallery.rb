module Blacksand
  class Property::Gallery < Property
    has_many :pictures, as: :imageable, class_name: 'Blacksand::Picture', dependent: :destroy

    accepts_nested_attributes_for :pictures, reject_if: :all_blank, allow_destroy: true
  end
end
