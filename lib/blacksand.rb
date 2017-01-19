require "blacksand/engine"

require 'blacksand/my_json_type' if defined? ActiveRecord

module Blacksand
  # inspired by rails-admin https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config.rb#L104
  DEFAULT_AUTHENTICATION = proc {}

  def self.table_name_prefix
  end

  mattr_accessor :site_id
  mattr_accessor :site_name
  mattr_accessor :root_path

  mattr_accessor :carrierwave_storage


  self.carrierwave_storage = :file

  def self.authenticate_with(&block)
    @authenticate = block if block
    @authenticate || DEFAULT_AUTHENTICATION
  end
end
