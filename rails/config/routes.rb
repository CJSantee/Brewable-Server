Rails.application.routes.draw do
	# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
	get '/' => 'application#home'
	get '/forbidden' => 'application#forbidden'
	
	namespace :api do 
		namespace :v1 do 
			post '/auth' => 'authentication#create'
			get '/refresh' => 'authentication#refresh'
			delete '/auth' => 'authentication#destroy'

			resources :users, only: [:index, :show, :update, :create] do 
				resources :posts, only: [:index, :show, :update, :create, :destroy] 
				get '/feed' => 'posts#feed'
				post '/follow' => 'follows#follow'
				post '/unfollow' => 'follows#unfollow'
				get '/follows' => 'follows#counts'
				get '/mutual' => 'follows#mutual'
				get '/followers' => 'follows#followers'
				get '/following' => 'follows#following'
				get '/roles' => 'roles#user_roles'
				post '/roles' => 'roles#assign_roles'
				get '/permissions' => 'permissions#user_permissions'
			end

			get '/posts' => 'posts#discover'

			resources :roles, only: [:index, :create] do 
				get '/users' => 'roles#users'
				resources :permissions, only: [:index, :create]
			end

			resources :beans, only: [:index, :show, :create]
			resources :bags, only: [:create]

			get '/photos' => 'photos#show'
			post '/presigned_url' => 'uploads#create'
		end
	end
end