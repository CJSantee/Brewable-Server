require 'aws-sdk-s3'

def get_photo(photo_uri)
	s3_client = Aws::S3::Client.new(region: ENV['AWS_REGION'])
	begin
		response = s3_client.get_object(
			bucket: ENV['S3_BUCKET'],
			key: photo_uri,
		)
	rescue => e
	  puts "Error retrieving photo (#{photo_uri}) to AWS: #{e.message}"
	end
end