module Blacksand
  class Dashboard::BaseController < ActionController::Base
    layout 'blacksand/dashboard'

    before_action :_authenticate!
    before_action :_authorize!

    helper_method :_current_user
    helper_method :visible?

    attr_reader :authorization_adapter

    private
    def _authenticate!
      instance_eval(&Blacksand.authenticate_with)
    end

    def _authorize!
      instance_eval(&Blacksand.authorize_with)
    end

    def _current_user
      instance_eval(&Blacksand.current_user_method)
    end

    def visible?(action, object)
      # 如果启用了授权
      if self.authorization_adapter
        return self.authorization_adapter.authorized?(action, object)
      end

      true
    end
  end
end