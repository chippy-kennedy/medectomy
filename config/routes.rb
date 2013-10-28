Medectomy::Application.routes.draw do
  root to: 'prelaunch#index'
  post '/subscribe', to: 'prelaunch#subscribe'
end
