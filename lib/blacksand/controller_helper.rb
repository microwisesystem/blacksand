module Blacksand
  module ControllerHelper
    extend ActiveSupport::Concern

    class_methods do

      # 应用 theme, 加载导航, 引用 helper method 到 view
      def blacksand
        theme Blacksand.site_id
        loan_navigations
        helper BlacksandFront::PagesHelper
      end

      def loan_navigations
        before_action do
          @navigations = Blacksand::Navigation.includes(page: :positioned_children).order(:position)
        end
      end
    end
  end
end