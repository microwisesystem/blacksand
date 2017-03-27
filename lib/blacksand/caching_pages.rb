module Blacksand
  module CachingPages
    extend ActiveSupport::Concern

    included do
      caches_page :show
    end
  end
end