class Api::V1::UsersController < ApplicationController
    skip_before_action :authenticate, only: [:create]

    # GET /users
    def index
        @users = User.all
        render json: @users
    end

    # POST /users
    def create
        @user = User.new(user_params)
        if @user.save 
            payload = { user_id: @user.id }
            token = create_token(payload)
            render json: {user: @user, token: token}, status: :created
        else
            render json: @user.errors, status: :unprocessable_entity 
        end
    end
  
    private
    def user_params
        params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end
end
