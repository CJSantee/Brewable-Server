class Api::V1::AuthenticationController < ApplicationController

	# GET /api/v1/auth 
	# Login User
	def create
		user = params[:email] ? User.find_by(email: params[:email].downcase) : User.find_by(phone: params[:phone])
		if user
			if (user.authenticate(params[:password]))
				payload = { user_id: user.id }
				secret = ENV['SECRET_KEY_BASE'] || Rails.application.secrets.secret_key_base
				token = create_token(payload)
				cookies[:jwt] = {
					value: token,
					httpOnly: true,
				}
				render json: { access_token: token, user: UsersRepresenter.new([user], user).for_auth }
			else
				render json: { error: { code: "INVALID_CREDENTIALS", message: "Incorrect login or password." }}, status: error_status(:unauthorized)
			end
		else
			render json: { error: { code: "NOT_FOUND", message: "User not found." }}, status: :not_found
		end
	end

	# GET /api/v1/backdoor
	# TODO: must be signed in as admin!
	def backdoor 
		user = User.find(params[:user_id])
		if user
			payload = { user_id: user.id }
			secret = ENV['SECRET_KEY_BASE'] || Rails.application.secrets.secret_key_base
			token = create_token(payload)
			cookies[:jwt] = {
				value: token,
				httpOnly: true,
			}
			render json: { access_token: token, user: UsersRepresenter.new([user], user).for_auth }
		else
			render json: { error: { code: "NOT_FOUND", message: "User not found." }}, status: :not_found
		end
	end

	# GET /api/v1/refresh
	def refresh
		token = cookies[:jwt]
		if token 
			begin
				decoded_token = JWT.decode(token, secret)
				payload = decoded_token.first
				user_id = payload["user_id"]
				user = User.find(user_id)
				if user
					payload = { user_id: user.id }
					token = create_token(payload)
					cookies[:jwt] = {
						value: token,
						httpOnly: true,
					}
					render json: { access_token: token, user: UsersRepresenter.new([user], user).for_auth }, status: :ok
				else
					render json: { error: { message: "User not found" }}, status: :unauthorized
				end
			rescue => exception
				render json: { error: { message: "Error: #{exception}" }}, status: :internal_server_error
			end
		else
			render json: { error: { message: "Token cookie not found" }}, status: :not_found
		end
	end

	# DELETE /api/v1/auth
	# Logout User
	def destroy
		cookies.delete(:jwt)
		render json: { message: "Successfully logged out!" }
	end

end
