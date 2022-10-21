class UsersRepresenter
	def initialize(users, req_user)
		@users = users
		@req_user = req_user
	end

	def as_json
		@users.map do |user|
			{
				user_id: user.id,
				username: user.username,
				name: user.name,
				email: user.email,
				phone: user.phone,
				bio: user.bio,
				posts_count: user.posts.select{|post| !post.archived_at.nil?}.count,
				followers_count: user.followers.count,
				following_count: user.following.count,
				image: user.image,
				following: following(user),
				roles: user.roles.map do |role|
					role.name
				end
			}
		end
	end

	def for_auth
		@users.map do |user|
			{
				user_id: user.id, 
				name: user.name, 
				username: user.username, 
				roles: user.roles.map do |role|
					role.name
				end
			}
		end.first
	end

	def following(user)
		if @req_user.nil?
			return false
		else
			return @req_user.following.include?(user)
		end
	end

	private
	attr_reader :users
end