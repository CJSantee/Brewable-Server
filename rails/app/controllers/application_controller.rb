class ApplicationController < ActionController::API
	include ::ActionController::Cookies
	before_action :authenticate
	before_action :set_cors
	skip_before_action :authenticate, only: [:home]

	MAX_PAGINATION_LIMIT = 100

	def home 
		render json: { welcome: 'Welcome to the Brewable API!' }, status: :ok
	end

	def authenticate
		token = cookies[:jwt]
		if token 
			begin
				decoded = JWT.decode(token, secret)[0]
				user_id = decoded["user_id"]
				@req_user = User.find(user_id)
			rescue => exception
				render json: { message: "Error: #{exception}" }, status: :forbidden
			end
		else
			render json: { message: 'Token cookie not found' }, status: :forbidden
		end
	end

	def secret
		secret = ENV['SECRET_KEY_BASE'] || Rails.application.secrets.secret_key_base
	end

	def create_token(payload)
		JWT.encode(payload, secret)
	end

	def set_cors
		headers['Access-Control-Allow-Origin'] = ENV['CLIENT_URL']
		headers['Access-Control-Request-Method'] = '*'
	end

	def limit
		[
			params.fetch(:limit, MAX_PAGINATION_LIMIT).to_i,
			MAX_PAGINATION_LIMIT
		].min
	end

	def set_pagination_headers(object)
		response.headers['X-Pagination'] = {
			total: object.total_entries,
			total_pages: object.total_pages,
			first_page: object.current_page === 1,
			last_page: object.next_page.blank?,
			previous_page: object.previous_page,
			next_page: object.next_page,
			out_of_bounds: object.out_of_bounds?,
			offset: object.offset
		}.to_json
	end

	def error_status(status)
		if Rails.env.production? 
			return :ok 
		else
			return status
		end
	end

	def confirm_permission(permission)
		roles = @req_user.roles
		roles.each do |role|			
			permissions = role.permissions.map do |permissionObj|
				permissionObj.permission
			end
			return true if permissions.include?(permission)
		end
		render json: { message: 'You do not have permission to access this resource.' }, status: :forbidden
		return false
	end

	# For application_spec.rb
	def forbidden 
		return if !confirm_permission('noOneShouldHaveThisPermission')
	end
end
