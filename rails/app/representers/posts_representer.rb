class PostsRepresenter
	include TimeSince

	def initialize(posts, req_user)
		@posts = posts
		@req_user = req_user
	end

	def as_json 
		@posts.map do |post|
			user = User.find(post.user_id)
			{
				post_id: post.id,
				name: user.name,
				username: user.username,
				caption: post.caption,
				created_at: post.created_at.in_time_zone(@req_user.time_zone),
				display_time: time_since(post.created_at),
				edited: post.created_at != post.updated_at,
			}
		end
	end
end