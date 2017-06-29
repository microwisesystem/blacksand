module Blacksand
  class Navigation < ActiveRecord::Base
    belongs_to :page, required: false

    # ActiveRecord attribute api changed, see http://api.rubyonrails.org/classes/ActiveRecord/Attributes/ClassMethods.html#method-i-attribute
    if ActiveRecord::VERSION::MAJOR >= 5
      attribute :options, :json_type
    else
      attribute :options, MyJsonType.new
    end

    validates :name, presence: true
    validates :url, format: {with: URI.regexp}, if: Proc.new { |a| a.url.present? }

    validate :url_or_page_presence

    def url_or_page_presence
      if url.blank? && page_id.blank?
        errors.add(:url, "链接或者页面两个必须要填一项")
        errors.add(:page_id, "链接或者页面两个必须要填一项")
      end
    end
  end
end
