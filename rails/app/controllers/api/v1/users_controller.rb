class Api::V1::UsersController < ApplicationController
	skip_before_action :authenticate, only: [:create]

	# GET /api/v1/users
	def index
		# return if !confirm_permission('users:get')
		users = User.all
		users = users.filter_by_query(params[:query]) if params[:query].present?
		users = users.paginate(page: params[:page], per_page: limit)
		render json: UsersRepresenter.new(users, @req_user).as_json, status: :ok
		set_pagination_headers(users)
	end

	# GET /api/v1/users/:id
	def show
		user = User.find(params[:id])
		render json: UsersRepresenter.new([user], @req_user).as_json[0], status: :ok
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
			render json: { access_token: token, user: { user_id: user.id, name: user.name, username: user.username }}, status: :created
		else
			# TODO: Return 409 (:conflict) for email / phone already in use
			render json: user.errors, status: :unprocessable_entity
		end
	end

	# PATCH /api/v1/users/:id
	def update
		user = User.find(params[:id])
		if user.update(user_params)
			render json: UsersRepresenter.new([User.find(user.id)], @req_user).as_json.first, status: :ok
		else
			render json: user.errors, status: :unprocessable_entity
		end
	end

	private
	def user_params
		params.require(:user).permit(:name, :username, :email, :phone, :password, :image_uri)
	end
end
