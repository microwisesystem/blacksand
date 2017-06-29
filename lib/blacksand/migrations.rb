require 'thor/group'

module Blacksand
  class Migrations < Thor
    include Thor::Actions

    # 修正 migration 的父类，默认是 ActiveRecord::Migration, 但是 Rails 5.1 以后，
    # 必须指定版本，例如 ActiveRecord::Migration[5.1]
    def fix_migration_super_class
      if ActiveRecord::VERSION::MAJOR > 5 || ( ActiveRecord::VERSION::MAJOR == 5 && ActiveRecord::VERSION::MINOR >= 1 )
        puts "Fix migration super class"
        Dir.glob("db/migrate/*.blacksand.rb") do |file|
          gsub_file(file, /ActiveRecord::Migration$/, "ActiveRecord::Migration[#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}]")
        end
      end
    end
  end
end