require 'rails/generators'

module Blacksand
  module Generators
    class InstallGenerator < Rails::Generators::Base

      def install
        create_file("config/initializers/blacksand.rb", <<-RUBY)
Blacksand.site_id   = 'site id'
Blacksand.site_name = 'site name'

# Config carrierwave
#
# Blacksand.carrierwave_storage          = :file # or :qiniu
# Blacksand.carrierwave_store_dir_prefix = "uploads" # NOTICE: Kindeditor need config their own configuration

# Setup authentication to be run as a before filter 
# @example Devise admin
#   Blacksand.authenticate_with do
#     authenticate_admin!
#   end

# Page caching
# Blacksand.page_caching = false
        RUBY

        rake 'railties:install:migrations'
      end
    end
  end
end
