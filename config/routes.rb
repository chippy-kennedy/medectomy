Medectomy::Application.routes.draw do
  post '/subscribe', to: 'prelaunch#subscribe'
  resources :subscribers
  get '/contact', to: 'prelaunch#contact'
  get '/product', to: 'prelaunch#product'
  get '/index', to: 'prelaunch#index'
   root to: 'prelaunch#index'
end
