class Api::V1::LikesController < ApplicationController 
	before_action :get_user, only: [:index, :create, :destroy]

	# GET /api/v1/posts/:post_id/likes
	def index
		post = Post.find(params[:post_id])
		likers = post.likers
		render json: UsersRepresenter.new(likers, @req_user).as_json, status: :ok
	end

	# POST /api/v1/posts/:post_id/likes
	def create 
		user_id = params[:user_id] || @req_user.id
		Like.create(user_id: user_id, post_id: params[:post_id])
		render json: { message: "Success" }, status: :created
	end

	# DELETE /api/v1/posts/:post_id/likes/:user_id
	def destroy
		user_id = params[:user_id] || @req_user.id
		like = Like.find_by(post_id: params[:post_id], user_id: user_id)
		if (like) 
			like.destroy
			render json: { message: "Success" }, status: :ok
		else
			render json: { error: { code: "NOT_FOUND", message: "Like not found." }}, status: :not_found 
		end
	end

end