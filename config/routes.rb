Rails.application.routes.draw do
  resources :products
  root to: 'user#login'

  get 'user/login'

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'test', to: 'application#test'

  get 'user/login_callback', to: 'user#login_callback'
  get 'user/logout_callback', to: 'user#logout_callback'
  get 'user/user_info', to: 'user#user_info'
  get 'user/user_friends', to: 'user#user_friends'

  get 'calculate_personality', to: 'user#calculate'


end
