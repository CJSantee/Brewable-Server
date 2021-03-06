class Api::V1::AuthenticationController < ApplicationController
    skip_before_action :authenticate, only: [:login]

    def login
        @user = User.find_by("email = ? OR username = ?", params[:emailOrUsername], params[:emailOrUsername])
        if @user
            if (@user.authenticate(params[:password]))
                payload = { user_id: @user.id }
                secret = ENV['SECRET_KEY_BASE'] || Rails.application.secrets.secret_key_base
                token = create_token(payload)
                render json: { token: token }
            else
                render json: { message: "Authentication Failed" }, status: :forbidden
            end
        else
            render json: { message: "Could not find user" }, status: :forbidden
        end
    end
end
