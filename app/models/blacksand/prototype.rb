module Blacksand
  class Prototype < ActiveRecord::Base
    has_many :fields, dependent: :destroy

    accepts_nested_attributes_for :fields

    has_many :pages, dependent: :nullify
  end
end
