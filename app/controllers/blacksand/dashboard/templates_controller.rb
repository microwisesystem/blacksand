module Blacksand
  class Dashboard::TemplatesController < Dashboard::BaseController

    def index
      @templates = Template.all
    end
  end
end
