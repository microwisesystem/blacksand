# 与 blacksand 隔离开, 否则路由会映射到 dashboard 下面的 pages_controller
module BlacksandFront
  class PagesController < ApplicationController
    theme Blacksand.site_id
    loan_navigations

    def show
      @page = Blacksand::Page.find params[:id]
      set_meta_tags title: @page.title

      # render template
      if @page.template.present?
         render @page.template.path
      end
    end
  end
end
