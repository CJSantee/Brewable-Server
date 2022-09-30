class Api::V1::PermissionsController < ApplicationController

	# GET /api/v1/users/:id/permissions
	# Get all permissions granted to user
	def user_permissions
		user = User.find(params[:user_id])
		permissions = user.permissions.map do |permissionObj|
			permissionObj.permission
		end
		render json: permissions, status: :ok
	end

	# GET /api/v1/roles/:id/permissions
	# Gets all permissions associated with role 
	def index
		role = Role.find(params[:role_id])
		permissions = role.permissions.map do |permissionObj| 
			permissionObj.permission
		end
		render json: permissions, status: :ok
	end

	# POST /api/v1/roles/:id/permissions
	# Create new permission for role
	def create
		role = Role.find(params[:role_id])
		permissions = params[:permissions]
		permissions.each do |permission|
			Permission.create(role_id: role.id, permission: permission)
		end
		render json: { message: 'Successfully added permissions.' }, status: :created
	end

end