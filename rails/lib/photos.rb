require 'aws-sdk-s3'

def get_photo(photo_uri)
	s3_client = Aws::S3::Client.new(region: ENV['AWS_REGION'])
	begin
		response = s3_client.get_object(
			bucket: ENV['S3_BUCKET'],
			key: photo_uri,
		)
		response.body
	rescue => StandardError => e
	  puts "Error retrieving photo (#{photo_uri}) to AWS: #{e.message}"
	end
end

def upload_photo()
	s3_client = Aws::S3::Client.new(region: ENV['AWS_REGION'])
	begin
		response = s3_client.put_object(
			bucket: ENV['S3_BUCKET'],
			key: photo_uri
		)
	rescue => StandardError => e
		puts "Error uploading photo (#{photo_uri}) to AWS: #{e.message}"
	end
end