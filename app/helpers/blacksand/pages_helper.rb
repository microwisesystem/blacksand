module Blacksand
  module PagesHelper
    def page(en_name)
      Page.where(en_name: en_name).first
    end

    def textarea2html(text)
      text.split(' ').join('<br>').html_safe if text.present?
    end

    def set_page_options(hash)
      @_page_options ||= {}
      @_page_options.merge!(hash)
    end

    def page_options
      @_page_options || {}
    end
  end
end
