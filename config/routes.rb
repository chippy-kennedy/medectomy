Medectomy::Application.routes.draw do

  devise_for :users

  resources :courses
  resources :chapters
  
  resources :enrollments


  # route for user profile
  #TODO: Below not working during intial signin
  get 'profile', :to => 'users#index'

  root to: 'pages#home'
	
  # routes for navigation on front pages 
  get 'available_courses', :to => 'pages#available_courses'
  get 'contact', :to => 'pages#contact'



end
