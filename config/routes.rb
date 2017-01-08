Rails.application.routes.draw do
  get 'user/login'

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'test', to: 'application#test'

  get 'index', to: 'user#index'
  get 'login', to: 'user#login'
  get 'login_callback', to: 'user#login_callback'
  get 'get_token', to: 'user#get_token'
  get 'logout_callback', to: 'user#logout_callback'
  get 'user_info', to: 'user#user_info'
  get 'user_friends', to: 'user#user_friends'
end
