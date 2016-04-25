module Blacksand
  class Navigation < ActiveRecord::Base
    belongs_to :page

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
