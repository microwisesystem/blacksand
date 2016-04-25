Rails.application.routes.draw do
  scope module: 'blacksand' do
    resources :pages, only: :show, path: :p

    namespace :dashboard do
      get '/' => redirect('/dashboard/pages')

      # TODO
      # resources :users

      resources :pages, except: [:show] do
        collection do
          get 'onchange_new'
          post 'sort'

          get 'children_partial'
        end

        member do
          get 'onchange_edit'
          get 'get_prototype_id'
          get 'render_manage'
        end
      end

      resources :navigations do
        post :reorder, on: :collection
      end

      resources :templates, only: [:index]
      resources :prototypes, only: [:index, :show]
    end
  end
end
