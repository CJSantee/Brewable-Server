class Bean < ApplicationRecord
	has_many :bags

	after_create :generate_uuid

	def image 
		if image_uri && !ENV['RETURN_AWS_URLS']='false'
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

	private
		def generate_uuid
			uuid = SecureRandom.base64(10)
			uuid.gsub! '+','~'
			uuid.gsub! '/','_'
			self.beans_uuid = uuid
		end
end
