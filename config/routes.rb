Medectomy::Application.routes.draw do

  devise_for :users
  resources :subscribers

  resources :courses do
  	resources :chapters
  end

  #root to: 'prelaunch#index'

  get '/contact', to: 'prelaunch#contact'
  get '/product', to: 'prelaunch#product'

  get  '/index', to: 'courses#index'
  get  'dashboard/index', to: 'dashboard#index'

  #post '/subscribe', to: 'prelaunch#subscribe'

  root to: 'dashboard#index'

end
