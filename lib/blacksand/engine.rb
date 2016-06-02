require 'rails'
require 'carrierwave'
require 'rails_kindeditor'
require 'mini_magick'
require 'kaminari'
require 'bootstrap-kaminari-views'
require 'gon'
require 'meta-tags'
require 'bootstrap-sass'
require 'bootstrap_form'
require 'nested_form'
require 'bootstrap-datepicker-rails'
require 'font-awesome-rails'
require 'enumerize'
require 'ransack'

require 'rails-assets-util.css'
require 'rails-assets-html5shiv'
require 'rails-assets-respond'
require 'rails-assets-eonasdan-bootstrap-datetimepicker'
require 'rails-assets-headroom.js'
require 'rails-assets-dragula'
require 'rails-assets-bootstrap-treeview'
require 'rails-assets-multiselect'
require 'rails-assets-select2'
require 'blacksand/routing'

module Blacksand
  def self.table_name_prefix
  end

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

  end
end
