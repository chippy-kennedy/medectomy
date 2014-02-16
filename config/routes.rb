Medectomy::Application.routes.draw do

  devise_for :users

  resources :courses do
  	resources :chapters
  end

  resources :dashboard do
    resources :notes
  end

  root to: 'dashboard#index'

end
