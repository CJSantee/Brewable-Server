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
				followers_count: user.followers.count,
				following_count: user.following.count,
				image: user.image,
				following: @req_user.following.include?(user),
				roles: user.roles.map do |role|
					role.name
				end
			}
		end
	end

	private
	attr_reader :users
end