require 'rails/generators'

module Blacksand
  module Generators
    class InstallGenerator < Rails::Generators::Base

      def install
        create_file("config/initializers/blacksand.rb", <<-RUBY)
Blacksand.site_id   = 'site id'
Blacksand.site_name = 'site name'
Blacksand.root_path = 'root path'
        RUBY

        rake 'railties:install:migrations'
      end
    end
  end
end
