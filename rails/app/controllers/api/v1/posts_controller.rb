class Api::V1::PostsController < ApplicationController
	
	# GET /api/v1/posts
	def discover
		posts = Post.all
		posts = posts.paginate(page: params[:page], per_page: limit)
		render json: posts, status: :ok
		set_pagination_headers(posts)
	end

	# GET /api/v1/users/:id/posts
	def index
		user = User.find(params[:user_id])
		posts = user.posts
		posts = posts.paginate(page: params[:page], per_page: limit)
		render json: posts, status: :ok
		set_pagination_headers(posts)
	end

	# GET /api/v1/users/:id/feed
	def feed
		user = User.find(params[:user_id])
		followed_users = user.following.ids
		posts = Post.where(user_id: followed_users)
		posts = posts.paginate(page: params[:page], per_page: limit)
		render json: posts, status: :ok
		set_pagination_headers(posts)
	end

	# GET /api/v1/users/:id/posts/:id
	def show
		post = Post.find(params[:id])
		render json: post, status: :ok
	end

	# POST /api/v1/users/:id/posts
	def create
		post = Post.new(user_id: params[:user_id], caption: params[:caption])
		if post.save 
			render json: post, status: :created 
		else  
			render json: post.errors, status: :unprocessable_entity
		end
	end

	# PATCH /api/v1/users/:id/posts/:id
	def update
		post = Post.find(params[:id])
		if post.update(caption: params[:post][:caption])
			render json: post.to_json
		else
			render json: post.errors, status: :unprocessable_entity
		end
	end

	# DELETE /api/v1/users/:id/posts/:id
	def destroy 
		post = Post.find(params[:id])
		if post.update(archived_at: DateTime.now)
			render json: post.to_json
		else
			render json: post.errors, status: :unprocessable_entity
		end
	end

end