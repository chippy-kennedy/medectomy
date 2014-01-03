Medectomy::Application.routes.draw do

  resources :subscribers

  resources :courses do
  	resources :chapters
  end

  #root to: 'prelaunch#index'

  get '/contact', to: 'prelaunch#contact'
  get '/product', to: 'prelaunch#product'

  #post '/subscribe', to: 'prelaunch#subscribe'

  root to: 'courses#index'

end