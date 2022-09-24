class UsersRepresenter
	def initialize(users)
		@users = users
	end

	def as_json
		users.map do |user|
			{
				id: user.id,
				username: user.username,
				first_name: user.first_name,
				last_name: user.last_name,
				email: user.email,
				phone: user.phone,
				image: user.image
			}
		end
	end

	private
	attr_reader :users
end