module Blacksand
  class Field < ActiveRecord::Base
    extend Enumerize

    belongs_to :prototype
    has_many :properties, dependent: :destroy

    validates :name, :description, :field_type, presence: true
    validates :options, presence: true, if: 'select?'

    enumerize :field_type, in: %w{date number string textarea rich_text image gallery array slide file select page}
    serialize :options, JSON

    default_scope { order(:id) }

    after_save :check_properties

    protected

    def select?
      field_type == 'select'
    end

    def check_properties
      # 根据 prototype 查询 page 会更高效 @gaohui 2015.11.25
      self.prototype.pages.find_each do |page|
        (self.prototype.fields.map(&:id) - page.properties.map(&:field_id)).each do |field_id|
          field = Field.find field_id
          Property.build_property(page, field)
        end
        page.save(validate: false)
      end
    end

  end
end
