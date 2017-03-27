module Blacksand
  module ExpirePages
    extend ActiveSupport::Concern
    
    included do
      after_action :expire_cache_pages, only: [:create, :update, :destroy]
    end


    def expire_cache_pages
      expire_page root_path if defined? root_path

      # TODO: 有点暴力, 可以扫描缓存文件夹,挨个删除
      Blacksand::Page.find_each do |p|
        expire_page Rails.application.routes.url_helpers.page_path(p)
      end
    end
  end
end