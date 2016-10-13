require 'rails'
require 'carrierwave'
require 'carrierwave-qiniu'
require 'rails_kindeditor'
require 'mini_magick'
require 'kaminari'
require 'bootstrap-kaminari-views'
require 'gon'
require 'meta-tags'
require 'bootstrap-sass'
require 'bootstrap_form'
require 'cocoon'
require 'font-awesome-rails'
require 'enumerize'
require 'ransack'
require 'themes_on_rails'

require 'rails-assets-util.css'
require 'rails-assets-html5shiv'
require 'rails-assets-respond'
require 'rails-assets-bootstrap-datepicker'
require 'rails-assets-headroom.js'
require 'rails-assets-dragula'
require 'rails-assets-bootstrap-treeview'
require 'rails-assets-multiselect'
require 'rails-assets-select2'

require 'blacksand/routing'
require 'blacksand/controller_helper'
require 'blacksand/uploader'

module Blacksand

  class Engine < ::Rails::Engine
    isolate_namespace Blacksand

    initializer "blacksand.precompile", group: :all do |app|

      # USING: rake blacksand_engine:install:migrations
      #
      # config.paths["db/migrate"].expanded.each do |expanded_path|
      #   app.config.paths["db/migrate"] << expanded_path
      # end

      app.config.assets.precompile += %w(
        blacksand/dashboard.js
        blacksand/dashboard.css
        blacksand/ie.js
      )
    end

    ActiveSupport.on_load :action_controller do
      include ControllerHelper
    end

  end
end
