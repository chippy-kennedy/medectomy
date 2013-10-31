Medectomy::Application.routes.draw do
  post '/subscribe', to: 'prelaunch#subscribe'
  resources :subscribers

   root to: 'prelaunch#index'
end
