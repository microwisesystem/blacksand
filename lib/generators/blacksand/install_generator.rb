require 'rails/generators'

module Blacksand
  module Generators
    class InstallGenerator < Rails::Generators::Base

      def install
        create_file("config/initializers/blacksand.rb", <<-YAML)
Blacksand.site_id   = 'site id'
Blacksand.site_name = 'site name'
Blacksand.root_path = 'root path'
        YAML

        rake 'railties:install:migrations'
      end
    end
  end
end
