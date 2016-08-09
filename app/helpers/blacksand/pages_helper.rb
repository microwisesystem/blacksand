module Blacksand
  module PagesHelper
    def page(en_name)
      Page.where(en_name: en_name).first
    end

    def textarea2html(text)
      text.split(' ').join('<br>').html_safe if text.present?
    end
  end
end
