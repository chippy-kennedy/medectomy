Medectomy::Application.routes.draw do

  resources :subscribers

  resources :courses do
  	resources :chapters
  end

  #root to: 'dashboard#index'

  get '/contact', to: 'prelaunch#contact'
  get '/product', to: 'prelaunch#product'
  get '/index', to: 'prelaunch#index'

  #post '/subscribe', to: 'prelaunch#subscribe'

  root to: 'prelaunch#index'

end
