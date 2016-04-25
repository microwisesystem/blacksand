require 'rails/generators'

module Blacksand
  module Generators
    class NewSiteGenerator < Rails::Generators::NamedBase

      def new_site
        puts "Create Site: #{name}"
        # site yaml
        create_file("db/sites/#{name}.yml", <<-YAML)
# 模板
templates:
  # - your template

# 原型
prototypes:
  # - your prototype
YAML

        # site theme
        if yes?("Install theme #{name} ?(Y/n)")
          generate 'themes_on_rails:theme', name
        end
      end

    end
  end
end