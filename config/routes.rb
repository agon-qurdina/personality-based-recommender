Rails.application.routes.draw do
  root to: 'products#home'

  get '/products/home', to: 'products#home'

  resources :products do
    collection do
      post 'purchase'
    end
    member do
      get 'test_personality'
    end
  end

  get 'user/login'

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'test', to: 'application#test'

  get 'user/login_callback', to: 'user#login_callback'
  get 'user/logout_callback', to: 'user#logout_callback'
  get 'user/test_personality', to: 'user#test_personality'

  get 'get_fb_info', to: 'user#get_fb_info'
  get 'personality', to: 'user#personality'
  get 'calculate', to: 'user#calculate'

end
