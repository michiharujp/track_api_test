Rails.application.routes.draw do
  resources :users
  post 'signup', acition: :create, controller: 'users'
  get 'users/:user_id', action: :show, controller: 'users'
  patch 'users/:user_id', action: :update, controller: 'users'
  post 'users/close', action: :destroy, controller: 'users'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
