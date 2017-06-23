$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "blacksand/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "blacksand"
  s.version     = Blacksand::VERSION
  s.authors     = ["bastengao"]
  s.email       = ["bastengao@gmail.com"]
  s.homepage    = "https://github.com/microwisesystem/blacksand"
  s.summary     = "CMS base on Rails Engine."
  s.description = "CMS base on Rails Engin."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", ">= 4.2.6", '< 5.1'
  s.add_dependency "actionpack-page_caching"
  s.add_dependency "carrierwave"
  s.add_dependency "carrierwave-qiniu", '>= 0.2.6'
  s.add_dependency "kaminari"
  s.add_dependency 'bootstrap-kaminari-views'
  s.add_dependency "gon"
  s.add_dependency "meta-tags"
  s.add_dependency "bootstrap-sass"
  s.add_dependency 'bootstrap_form'
  s.add_dependency 'font-awesome-rails'
  s.add_dependency 'cocoon'
  s.add_dependency 'rails_kindeditor'
  s.add_dependency 'themes_on_rails'
  s.add_dependency 'enumerize'
  s.add_dependency 'ransack'


  s.add_dependency 'rails-assets-util.css'
  s.add_dependency 'rails-assets-html5shiv'
  s.add_dependency 'rails-assets-respond'
  s.add_dependency 'rails-assets-bootstrap-datepicker'
  s.add_dependency 'rails-assets-headroom.js'
  s.add_dependency 'rails-assets-dragula'
  s.add_dependency 'rails-assets-bootstrap-treeview'
  s.add_dependency 'rails-assets-multiselect'
  s.add_dependency 'rails-assets-select2'

  s.add_development_dependency "pg"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails"
  # s.add_development_dependency "factory_girl_rails"
end
