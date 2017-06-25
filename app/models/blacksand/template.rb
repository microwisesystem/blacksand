module Blacksand
  class Template < ActiveRecord::Base
    serialize :options, JSON
    store_accessor :options,  :preferred_child_template_name, :preferred_child_prototype_name

    validates :name, :path, presence: true

    has_many :pages, dependent: :nullify
  end
end
