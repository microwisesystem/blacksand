module Blacksand
  class Prototype < ActiveRecord::Base
    store_accessor :options,  :preferred_child_template_name, :preferred_child_prototype_name

    has_many :fields, dependent: :destroy

    accepts_nested_attributes_for :fields

    has_many :pages, dependent: :nullify
  end
end
