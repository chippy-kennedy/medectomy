Medectomy::Application.routes.draw do
  post '/subscribe', to: 'prelaunch#subscribe'
  resources :subscribers
  get '/contact', to: 'prelaunch#contact'
   root to: 'prelaunch#index'
end
