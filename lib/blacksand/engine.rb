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
require 'actionpack/page_caching'

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
require 'blacksand/caching_pages'
require 'blacksand/expire_pages'

module Blacksand

  class Engine < ::Rails::Engine
    isolate_namespace Blacksand

    # USING: rake blacksand_engine:install:migrations

    initializer "blacksand.precompile", group: :all do |app|
      app.config.assets.precompile += %w(
        blacksand/dashboard.js
        blacksand/dashboard.css
        blacksand/ie.js
      )
    end

    initializer "blacksand.override_upload_storage", after: "rails_kindeditor.image_process" do
      # Storage be same with Our uploaders
      Kindeditor::AssetUploader.class_eval do
        storage Blacksand.carrierwave_storage
      end
    end

    initializer "blacksand.page_caching", after: 'action_pack.page_caching' do |app|
      if Blacksand.page_caching
        BlacksandFront::PagesController.send(:include, CachingPages)
        Blacksand::Dashboard::PagesController.send(:include, ExpirePages)
        Blacksand::Dashboard::NavigationsController.send(:include, ExpirePages)
      end
    end

    ActiveSupport.on_load :action_controller do
      include ControllerHelper
    end

  end
end
