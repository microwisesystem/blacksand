require "blacksand/engine"
require "blacksand/cancancan"

require 'blacksand/my_json_type' if defined? ActiveRecord

module Blacksand
  # inspired by rails-admin https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config.rb#L104
  DEFAULT_AUTHENTICATION = proc {}
  DEFAULT_AUTHORIZE = proc {}
  DEFAULT_CURRENT_METHOD = proc {}

  def self.table_name_prefix
  end

  mattr_accessor :site_id
  mattr_accessor :site_name
  mattr_accessor :root_path

  mattr_accessor :carrierwave_storage
  mattr_accessor :carrierwave_store_dir_prefix

  mattr_accessor :page_caching

  self.carrierwave_storage = :file
  self.carrierwave_store_dir_prefix = 'uploads'
  self.page_caching = false

  def self.authenticate_with(&block)
    @authenticate = block if block
    @authenticate || DEFAULT_AUTHENTICATION
  end

  def self.current_user_method(&block)
    @current_user = block if block
    @current_user || DEFAULT_CURRENT_METHOD
  end

  def self.authorize_with(*args)
    extension = args.shift
    # 目前只支持 cancancan
    if extension.present? && extension == :cancancan
      @authorize = proc do
        @authorization_adapter = Blacksand::Cancancan.new(self)
      end

    elsif extension.present? && extension != :cancancan
      puts "Error: Authorization only supports cancancan"
    end

    @authorize || DEFAULT_AUTHORIZE
  end

end
