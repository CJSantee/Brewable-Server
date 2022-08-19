require 'aws-sdk-s3'
require "erb"
include ERB::Util

class Api::V1::PhotosController < ApplicationController
	
	# GET /api/v1/photos?photo_uri=
	def get_photo
		object_key = url_encode(params[:photo_uri])

		s3_client = Aws::S3::Client.new(region: 'us-east-1')
		begin
			resp = s3_client.get_object(
				bucket: 'brewable-s3',
				key: object_key,
			)
			image = resp.body
			render json: { data: Base64.encode64(image.read), content_type: 'image/webp' }, status: :ok
		rescue => exception
			render json: { message: "Error: #{exception}" }, status: :forbidden
		end
	end

end