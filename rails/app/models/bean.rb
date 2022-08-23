class Bean < ApplicationRecord
	has_many :bags

	def image 
		if photo_uri
			begin
				object = S3_BUCKET.object("uploads/#{photo_uri}")
				{
					sourceUrl: object.presigned_request(:get, expires_in: 3600)[0],
					contentType: object.content_type,
				}
			rescue
				nil
			end
		end
	end
end
