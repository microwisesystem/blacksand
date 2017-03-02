module Blacksand

  class Cancancan
    def initialize(controller)
      @controller = controller
      @controller.extend ControllerExtension
    end

    def authorized?(action, object)
      @controller.current_ability.can?(action, object)
    end

    module ControllerExtension
      def current_ability
        @current_ability ||= ::Ability.new(_current_user)
      end
    end
  end
end