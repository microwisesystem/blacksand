module Blacksand
  class Dashboard::PrototypesController < Dashboard::BaseController

    def index
      @prototypes = Prototype.all
    end

    def show
      @prototype = Prototype.find params[:id]
    end
  end
end
