class Api::V1::UsersController < ApplicationController
	skip_before_action :authenticate, only: [:create]

	# GET /api/v1/users
	def index
		users = User.all
		users = users.paginate(page: params[:page], per_page: limit)
		render json: UsersRepresenter.new(users).as_json, status: :ok
		set_pagination_headers(@users)
	end

	# GET /api/v1/users/:id
	def show
		user = User.find(params[:id])
		render json: {
			id: user.id,
			first_name: user.first_name,
			last_name: user.last_name,
			email: user.email,
			phone: user.phone,
			image: user.image,
		}, status: :ok
	end

	# POST /api/v1/users
	def create 
		user = User.new(user_params)
		if user.save
			payload = { user_id: user.id }
			token = create_token(payload)
			cookies[:jwt] = {
				value: token,
				httponly: true,
			}
			render json: { access_token: token, user: { user_id: user.id, first_name: user.first_name, last_name: user.last_name }}, status: :created
		else
			# TODO: Return 409 (:conflict) for email / phone already in use
			render json: user.errors, status: :unprocessable_entity
		end
	end

	# PATCH /api/v1/users/:id
	def update
		user = User.find(params[:id])
		if user.update(user_params)
			render json: User.find(params[:id]).to_json(:only => [:id, :first_name, :last_name, :email, :phone, :image_uri]), status: :ok
		else
			render json: user.errors, status: :unprocessable_entity
		end
	end

	private
	def user_params
		params.require(:user).permit(:email, :phone, :password, :first_name, :last_name, :image_uri)
	end
end
