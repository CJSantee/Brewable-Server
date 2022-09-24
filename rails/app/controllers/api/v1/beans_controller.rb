class Api::V1::BeansController < ApplicationController

	# GET /api/v1/beans
	def index
		beans = Bean.all 
		beans = beans.paginate(page: params[:page], per_page: limit)
		render json: BeansRepresenter.new(beans).as_json, status: :ok
		set_pagination_headers(beans)
	end

	def show
		beans = Bean.where(beans_uuid: params[:id])
		render json: BeansRepresenter.new(beans).as_json, status: :ok
	end

	# POST /api/v1/beans
	def create
		bean = Bean.new(bean_params)
		if bean.save
			render json: bean, status: :created
		else
			render json: bean.errors, status: :unprocessable_entity
		end
	end

	private
	def bean_params
		params.require(:bean).permit(:name, :roaster, :origin, :flavor_notes)
	end
end