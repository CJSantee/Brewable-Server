class Api::V1::UploadsController < ApplicationController
	
	# POST /api/v1/presigned_url
	def create
		filename = params[:filename]
		file_type = params[:fileType]
		directory = params[:directory]
		key = "uploads/#{directory}/#{filename}"

		signer = Aws::S3::Presigner.new
		presigned_url = signer.presigned_url(:put_object, bucket: ENV['S3_BUCKET'], key: key, content_type: file_type)
		render json: { presigned_url: presigned_url }, status: :ok
	end

end