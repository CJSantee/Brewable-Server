class PostsRepresenter
	include TimeSince

	def initialize(posts, req_user)
		@posts = posts
		@req_user = req_user
	end

	def as_json 
		@posts.select{ |post| !archived(post) }.map do |post|
			user = User.find(post.user_id)
			{
				post_id: post.id,
				user_id: post.user_id,
				post_uuid: post.post_uuid,
				name: user.name,
				username: user.username,
				caption: post.caption,
				created_at: created_at(post),
				display_time: time_since(post.created_at),
				edited: post.created_at != post.updated_at,
				archived_at: post.archived_at,
			}
		end
	end

	def created_at(post)
		if @req_user.nil?
			post.created_at.in_time_zone("America/New_York")
		else
			post.created_at.in_time_zone(@req_user.time_zone)
		end
	end

	def archived(post)
		if @req_user.nil?
			!post.archived_at.nil?
		else
			if @req_user.roles.map { |role| role.name }.include?('admin')
				false
			else 
				!post.archived_at.nil?
			end
		end
	end
end