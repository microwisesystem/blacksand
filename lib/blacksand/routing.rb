module Blacksand
  module Routing
    def blacksand(path = :p)
      scope module: 'blacksand' do
        resources :pages, only: :show, path: path
      end
    end
  end
end

ActionDispatch::Routing::Mapper.send :include, Blacksand::Routing