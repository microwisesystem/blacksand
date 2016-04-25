module Blacksand
  class Template < ActiveRecord::Base
    validates :name, :path, presence: true

    has_many :pages, dependent: :nullify
  end
end
