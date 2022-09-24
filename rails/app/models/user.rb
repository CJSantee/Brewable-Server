class User < ApplicationRecord
	has_secure_password 
	has_many :bags
	
	validates :email, uniqueness: true
	validates :phone, uniqueness: true, :allow_blank => true

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