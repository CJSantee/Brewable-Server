require "erb"
require "photos"
include ERB::Util

class Api::V1::PhotosController < ApplicationController
	
	# GET /api/v1/photos?photo_uri=
	def show
		photo_uri = params[:photo_uri]
		begin 
			image = get_photo(photo_uri)
			object = S3_BUCKET.object(photo_uri)
			render json: { data: Base64.encode64(image.read), content_type: object.content_type }, status: :ok
		rescue => exception
			render json: { message: "Error: #{exception}" }, status: :forbidden
		end
	end

end