module Blacksand
  module PageHelper
    def url_for_page(page)
      if page.new_record?
        dashboard_pages_path(page)
      else
        dashboard_page_path(page)
      end
    end
  end
end