Medectomy::Application.routes.draw do

  devise_for :users

  resources :courses
  resources :chapters
  
  resources :enrollments

  
  #Change root to user/index if logged in
  authenticated :user do
    root to: "users#index", as: :authenticated_root
  end

  unauthenticated do
    root to: "pages#home", as: :unauthenticated_root
  end

  # route for user profile
  #TODO: Below not working during intial signin
  get 'profile', :to => 'users#index'
  get 'home', :to => 'pages#home'


  #root :to => 'users#index'
  root :to => 'pages#home'

	
  # routes for navigation on front pages 
  get 'available_courses', :to => 'pages#available_courses'


  get 'contact', :to => 'pages#contact'

  #special route for cancelling account
  #get 'cancel_account', :to => 'devise/registrations#cancel'

   

  

end
