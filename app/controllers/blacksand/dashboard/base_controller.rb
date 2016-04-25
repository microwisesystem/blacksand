module Blacksand
  class Dashboard::BaseController < ApplicationController
    layout 'blacksand/dashboard'

    # TODO: devise
    # before_action :authenticate_user!
  end
end