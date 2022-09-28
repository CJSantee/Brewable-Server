Rails.application.routes.draw do
	# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
	get '/' => 'application#home'
	
	namespace :api do 
		namespace :v1 do 
			post '/auth' => 'authentication#create'
			get '/refresh' => 'authentication#refresh'
			delete '/auth' => 'authentication#destroy'

			resources :users, only: [:index, :show, :update, :create] do 
				post '/follow' => 'follows#follow'
				get '/follows' => 'follows#counts'
				get '/mutual' => 'follows#mutual'
				get '/followers' => 'follows#followers'
				get '/following' => 'follows#following'
			end

			resources :beans, only: [:index, :show, :create]
			resources :bags, only: [:create]

			get '/photos' => 'photos#show'
			post '/presigned_url' => 'uploads#create'
		end
	end
end