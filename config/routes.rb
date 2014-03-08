Medectomy::Application.routes.draw do

  devise_for :users

  resources :courses 
  resources :chapters

  resources :dashboard do
    resources :notes
  end

  # route for user profile
  get 'profile', :to => 'users#index'

  root to: 'chapters#index'
  
end
