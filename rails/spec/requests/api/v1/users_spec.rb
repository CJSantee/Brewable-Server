require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
	
	before(:each) do 
		@user = User.new(
			first_name: "Test",
			last_name: "User",
			email: "brewableapp@gmail.com",
			password: "iLoveCoffee",
		)
		@user.save
		payload = { user_id: @user.id }
		token = JWT.encode(payload, ENV['SECRET_KEY_BASE'] || Rails.application.secrets.secret_key_base)
		cookies[:jwt] = token
	end

	describe "GET /users" do 
		it "returns all users" do 
			FactoryBot.create_list(:user, 5)

			get '/api/v1/users'
			
			expect(response).to have_http_status(:success)
			expect(JSON.parse(response.body).size).to eq(6)
		end
	end

	describe "GET /users/:id" do 
		it "returns an individual user" do 
			@user = FactoryBot.create(:user)

			get "/api/v1/users/#{@user.id}"

			expect(response).to have_http_status(:success)
			expect(JSON.parse(response.body)["first_name"]).to eq(@user.first_name)
		end
	end

	describe "POST /users" do 
		it "creates a new user" do 

			post "/api/v1/users", :params => {
				:user => {
					first_name: "Colin",
					last_name: "Santee",
					email: "colinsantee@email.com",
					password: "iLoveCoffee",
				}
			}

			expect(response).to have_http_status(:success)
			expect(JSON.parse(response.body)["user"]["first_name"]).to eq("Colin")
		end
	end

	describe "PATCH /users" do 
		it "updates an existing user" do
			@user = FactoryBot.create(:user)

			patch "/api/v1/users/#{@user.id}", :params => {
				:user => {
					first_name: "Colin",
				}
			}

			expect(response).to have_http_status(:success)
			expect(User.find(@user.id)["first_name"]).to eq("Colin")
		end
	end

end