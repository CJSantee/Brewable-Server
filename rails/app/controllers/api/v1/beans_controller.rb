class Api::V1::BeansController < ApplicationController
	# POST /api/v1/beans
	def create
		@bean = Bean.new(bean_params)
		if @bean.save
			render json: @bean, status: :created
		else
			render json: @bean.errors, status: :unprocessable_entity
		end
	end

	private
	def bean_params
		params.require(:bean).permit(:name, :roaster, :origin, :flavor_notes)
	end
end