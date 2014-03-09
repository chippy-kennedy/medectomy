Medectomy::Application.routes.draw do

  devise_for :users

  resources :courses do
  	resources :chapters
  end

  # route for user profile
  get 'profile', :to => 'users#index'

  root to: 'pages#home'
  
end
