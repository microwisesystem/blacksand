module Blacksand
  class Property < ActiveRecord::Base
    mount_uploader :image, ImageUploader

    # Disable this feature. It's not available in release.
    # ref: https://github.com/carrierwaveuploader/carrierwave/issues/1545
    #
    # mount_uploaders :gallery, ImageUploader

    belongs_to :page
    belongs_to :field
    default_scope { order(:field_id) }

    validate :check_field_required

    def check_field_required
      case (self.field.field_type)
        when 'image', 'slide' then
          errors.add(:image, "#{field.description}不能为空") if field.required? && !image.present?
        when 'gallery' then
          errors.add(:gallery, "#{field.description}不能为空") if field.required? && !gallery.present?
        else
          errors.add(:value, "#{field.description}不能为空") if field.required? && !value.present?
      end
    end

    def content
      case (self.field.field_type)
        when 'image', 'slide' then
          self.image
        when 'gallery' then
          self.gallery
        else
          self.value
      end
    end

    def as_subtype
      return if self.value.blank?

      case self.field.field_type
        when 'date' then
          Date.strptime(self.value, '%F')
        else
          self.value
      end
    end

    def self.build_property(page, field)
      if field.field_type == 'slide'
        page.properties.build(field: field, type: "Property::Slide")
      else
        page.properties.build(field: field)
      end
    end

  end
end
