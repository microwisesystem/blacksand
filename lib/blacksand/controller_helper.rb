module Blacksand
  module ControllerHelper
    extend ActiveSupport::Concern

    class_methods do

      def loan_navigations
        before_action do
          @navigations = Blacksand::Navigation.includes(page: :positioned_children).order(:position)
        end
      end
    end
  end
end