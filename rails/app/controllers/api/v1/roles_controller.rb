class Api::V1::RolesController < ApplicationController

	# GET /api/v1/roles
	# Gets all available roles
	def index
		roles = Role.all.map do |role|
			role.name
		end
		render json: roles, status: :ok
	end

	# GET /api/v1/users/:id/roles
	# Gets all roles for user :id
	def user_roles
		user = User.find(params[:user_id])
		roles = user.roles.map do |role|
			role.name
		end
		render json: roles, status: :ok
	end

	# GET /api/v1/roles/:id/users
	# Gets all users associated with role 
	def users
		role = Role.find(params[:role_id])
		users = role.users.paginate(page: params[:page], per_page: limit)
		render json: UsersRepresenter.new(users, @req_user).as_json, status: :ok
		set_pagination_headers(users)
	end

	# POST /api/v1/roles
	# Create new role
	def create 
		role = Role.new(role_params)
		if role.save
			render json: { id: role.id, name: role.name }, status: :created
		else 
			render json: role.errors, status: :unprocessable_entity
		end
	end

	# POST /api/v1/users/:id/roles
	# Assign roles to user
	def assign_roles
		user = User.find(params[:user_id])
		roles = params[:roles]
		roles.each do |name|
			role = Role.find_by(name: name)
			Assignment.create(user_id: user.id, role_id: role.id)
		end
		
		render json: { message: 'Roles successfully assigned.' }, status: :ok
	end

	# PATCH /api/v1/roles
	# Update role name

	private 
	def role_params
		params.require(:role).permit(:name)
	end
end