module Blacksand
  class Dashboard::BaseController < ActionController::Base
    layout 'blacksand/dashboard'

    before_action :_authenticate!

    private
    def _authenticate!
      instance_eval(&Blacksand.authenticate_with)
    end
  end
end