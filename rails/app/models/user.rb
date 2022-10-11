class User < ApplicationRecord
	has_secure_password 
	has_many :bags

	has_many :assignments
	has_many :roles, through: :assignments
	
	has_many :permissions, through: :roles

	has_many :posts

	# Will return an array of follows for the given user instance
	has_many :received_follows, foreign_key: :followed_id, class_name: "Follow", dependent: :destroy
	# Will return an array of users who follow the user instance
	has_many :followers, through: :received_follows, source: :follower
	# Will return an array of follows a user gave to someone else
	has_many :given_follows, foreign_key: :follower_id, class_name: "Follow", dependent: :destroy
	# Will return an array of other users who the user has followed
	has_many :following, through: :given_follows, source: :followed

	validates :username, uniqueness: true, :allow_blank => true
	validates :email, uniqueness: true
	validates :phone, uniqueness: true, :allow_blank => true

	scope :filter_by_query, -> (query) { where("lower(name) LIKE ?", "%#{query.downcase}%").or(where("username LIKE ?", "%#{query.downcase}%")) }
	scope :filter_by_username, -> (username) { where("username LIKE ?", "%#{username.downcase}%") }

	def image 
		if image_uri && !ENV['RETURN_AWS_URLS']='false'
			begin 
				object = S3_BUCKET.object("uploads/#{image_uri}")
			rescue
				nil
			end
			{
				sourceUrl: object.presigned_request(:get, expires_in: 3600)[0],
				contentType: object.content_type,
			}
		end
	end

end