Medectomy::Application.routes.draw do
  post '/subscribe', to: 'prelaunch#subscribe'

  resources :subscribers
  resources :courses do
  	resources :chapters
  end

  root to: 'dashboard#index'
end
