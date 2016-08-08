module Blacksand
  module PageHelper
    def url_for_page(page)
      if page.new_record?
        pages_path(page)
      else
        page_path(page)
      end
    end
  end
end