Rails.application.routes.draw do
  
  namespace :api do
    namespace :v1 do
      post '/users' => 'users#create'
      get '/users' => 'users#index'  
      post '/login' => 'authentication#login'
    end
  end
end
