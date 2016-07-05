require 'ostruct'
require 'active_record/connection_adapters/postgresql/oid/json'

module Blacksand
  # 为了能使 form 获取对象的状态,因为获取状态是使用  obj.send(name). 而默认 hash 是不能工作的。
  class MyJsonType < ::ActiveRecord::ConnectionAdapters::PostgreSQL::OID::Json

    # override active_record 4
    def type_cast_from_database(value)
      super_value = super

      if value.is_a?(::String)
        MyOpenStruct.new super_value
      else
        super_value
      end
    end

    # override active_record 4
    def type_cast_for_database(value)
      if value.is_a? MyOpenStruct
        ::ActiveSupport::JSON.encode(value.to_h)
      else
        super
      end
    end


    # override active_record 5
    def deserialize(value)
      super_value = super

      if value.is_a?(::String)
        MyOpenStruct.new super_value
      else
        super_value
      end
    end

    # override active_record 5
    def serialize(value)
      if value.is_a? MyOpenStruct
        ::ActiveSupport::JSON.encode(value.to_h)
      else
        super
      end
    end
  end

  class MyOpenStruct < OpenStruct
    # hack for bootstrap_form FormBuilder#required_attribute?
    def self.validators_on(*args)
      []
    end
  end
end

if ActiveRecord::VERSION::MAJOR >= 5
  puts "ActiveRecord Register json_type => Blacksand::MyJsonType, at #{__FILE__}:#{__LINE__}"
  ActiveRecord::Type.register(:json_type, Blacksand::MyJsonType, adapter: :postgresql)
end
