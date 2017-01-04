module Blacksand
  class Property::AsArray < Property
    serialize :values, Array
  end
end