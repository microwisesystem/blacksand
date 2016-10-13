Rails.application.routes.draw do
  mount Blacksand::Engine => "/cms"

  blacksand
end
