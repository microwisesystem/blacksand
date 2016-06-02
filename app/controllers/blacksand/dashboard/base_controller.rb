module Blacksand
  class Dashboard::BaseController < ActionController::Base
    layout 'blacksand/dashboard'

    # TODO: devise
    # before_action :authenticate_user!
  end
end