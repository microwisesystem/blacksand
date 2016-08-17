require "blacksand/engine"

require 'blacksand/my_json_type' if defined? ActiveRecord

module Blacksand
  def self.table_name_prefix
  end

  mattr_accessor :site_id
  mattr_accessor :site_name
  mattr_accessor :root_path
end
