require 'rails/generators'
require 'blacksand/migrations'

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

        copy_migrations
      end

      private
      def copy_migrations
        rake 'railties:install:migrations'

        Blacksand::Migrations.new.fix_migration_super_class
        # # 修正 migration 的父类，默认是 ActiveRecord::Migration, 但是 Rails 5.1 以后，
        # # 必须指定版本，例如 ActiveRecord::Migration[5.1]
        # if ActiveRecord::VERSION::MAJOR > 5 || ( ActiveRecord::VERSION::MAJOR == 5 && ActiveRecord::VERSION::MINOR >= 1 )
        #   puts "Fix migration super class"
        #   Dir.glob("db/migrate/*.blacksand.rb") do |file|
        #     gsub_file(file, /ActiveRecord::Migration$/, "ActiveRecord::Migration[#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}]")
        #   end
        # end
      end
    end
  end
end
