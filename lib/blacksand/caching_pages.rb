module Blacksand
  module CachingPages
    extend ActiveSupport::Concern

    included do
      caches_page :show
    end

    # 覆盖 actionpack-page_caching 的方法，如果页面带参数将不会生成缓存页。例如带分页的页面。
    def caching_allowed?
      return false if request.query_string.present?

      super
    end
  end
end