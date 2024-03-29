class Api::V1::FollowsController < ApplicationController
	before_action :authenticate, except: [:follow, :unfollow]
	before_action :get_user, only: [:followers, :following]

	# POST /api/v1/users/:id/follow => {followed_id: <followed_id>}
	def follow
		if params[:user_id] == params[:followed_id]
			render json: { error: "Cannot follow yourself." } 
			return
		end
		follower = User.find(params[:user_id])
		followed = User.find(params[:followed_id])
		follower.given_follows.create!(followed_id: followed.id)
		render json: {follower_id: follower.id, followed_id: followed.id}, status: :created
	end

	# POST /api/v1/users/:id/unfollow
	def unfollow
		follower = User.find(params[:user_id])
		followed = User.find(params[:followed_id])
		follow = Follow.where(follower_id: follower.id, followed_id: followed.id).first
		follow.destroy
		render json: { message: 'Sucessfully unfollowed.' }, status: :ok
	end

	# GET /api/v1/users/:id/follows
	def counts
		user = User.find(params[:user_id])

		# Followers: Users following :user_id, 
		followers = user.followers
		# Mutual: Users @req_user follows who also follow :user_id
		# FIXME VERY inefficient
		mutual = followers.select do |follower|
			@req_user.following.include?(follower)
		end
		# Following: Users followed by :user_id, 
		following = user.following

		render json: {mutual_count: mutual.count, followers_count: followers.count, following_count: following.count}, status: :ok
	end

	# GET /api/v1/users/:id/mutual
	def mutual
		user = User.find(params[:user_id])

		# FIXME Same as above, VERY inefficient
		mutual = user.followers.select do |follower|
			@req_user.following.include?(follower)
		end
	
		# Can't paginate because not active record collection after above
		# mutual = mutual.paginate(page: params[:page], per_page: limit) 

		render json: UsersRepresenter.new(mutual, @req_user).as_json, status: :ok
		# set_pagination_headers(mutual)
	end

	# GET /api/v1/users/:id/followers
	def followers
		# TODO: sorted with users followed by @req_user first

		followed = User.find(params[:user_id])
		followers = followed.followers.paginate(page: params[:page], per_page: limit)
		render json: UsersRepresenter.new(followers, @req_user).as_json, status: :ok
		set_pagination_headers(followers)
	end

	# GET /api/v1/users/:id/following
	def following
		# TODO: sorted with users followed by @req_user first

		follower = User.find(params[:user_id])
		following = follower.following.paginate(page: params[:page], per_page: limit)
		render json: UsersRepresenter.new(following, @req_user).as_json, status: :ok
		set_pagination_headers(following)
	end

end