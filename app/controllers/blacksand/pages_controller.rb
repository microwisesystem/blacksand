module Blacksand
  class PagesController < ApplicationController

    theme Blacksand.site_id

    def show
      @page = Page.find params[:id]
      set_meta_tags title: @page.title

      # render template
      if @page.template.present?
         render @page.template.path
      end
    end
  end
end
