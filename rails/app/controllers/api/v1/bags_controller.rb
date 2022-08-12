class Api::V1::BagsController < ApplicationController
	# POST /api/v1/bags
	def create
		@bag = Bag.new(bag_params)
		if @bag.save
			render json: @bag, status: :created
		else
			render json: @bag.errors, status: :unprocessable_entity
		end
	end

	private
	def bag_params
		params.require(:bag).permit(:bean_id, :user_id, :roast_level, :roast_date, :price, :weight, :weight_unit, :rating, :photo_uri, :favorite)
	end
end