class UsersRepresenter
	def initialize(users, req_user)
		@users = users
		@req_user = req_user
	end

	def as_json
		@users.map do |user|
			{
				id: user.id,
				username: user.username,
				name: user.name,
				email: user.email,
				phone: user.phone,
				followers_count: user.followers.count,
				following_count: user.following.count,
				image: user.image,
				following: @req_user.following.include?(user),
			}
		end
	end

	private
	attr_reader :users
end