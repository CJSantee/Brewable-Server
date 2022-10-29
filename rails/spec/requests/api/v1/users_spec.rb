require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
	
	before(:each) do 
		# Create User
		user = User.find(1)

		# Add JWT Cookie
		payload = { user_id: user.id }
		token = JWT.encode(payload, ENV['SECRET_KEY_BASE'] || Rails.application.secrets.secret_key_base)
		cookies[:jwt] = token
	end

	describe 'GET /users' do 
		it 'returns all users' do 
			FactoryBot.create_list(:user, 15)

			get '/api/v1/users', :params => {
				limit: 5,
			}
			
			# Check response status
			expect(response).to have_http_status(:success)
			# Check pagination (limit)
			expect(JSON.parse(response.body).size).to eq(5)
		end
	end

	describe 'GET /users/:id' do 
		it 'returns an individual user' do 
			user = FactoryBot.create(:user)

			get "/api/v1/users/#{user.id}"

			# Check response status
			expect(response).to have_http_status(:success)
			# Check response accuracy
			expect(JSON.parse(response.body)['user_id']).to eq(user.id)
			# Check response attributes
			expect(JSON.parse(response.body)).to include('user_id', 'username', 'name', 'email', 'phone', 'followers_count', 'following_count', 'image')
		end
	end

	describe 'GET /users?query=' do 
		it 'returns users when searching for name' do 
			user = FactoryBot.create(:user)

			get "/api/v1/users?query=#{user.name}"

			# Check response status
			expect(response).to have_http_status(:success)
			# Check response accuracy
			expect(JSON.parse(response.body)[0]['user_id']).to eq(user.id)
			# Check response attributes
			expect(JSON.parse(response.body)[0]).to include('user_id', 'username', 'name', 'email', 'phone', 'followers_count', 'following_count', 'image')
		end

		it 'returns users when searching for username' do 
			user = FactoryBot.create(:user)

			get "/api/v1/users?query=#{user.username}"

			# Check response status
			expect(response).to have_http_status(:success)
			# Check response accuracy
			expect(JSON.parse(response.body)[0]['user_id']).to eq(user.id)
			# Check response attributes
			expect(JSON.parse(response.body)[0]).to include('user_id', 'username', 'name', 'email', 'phone', 'followers_count', 'following_count', 'image')
		end
	end

	describe 'POST /users' do 
		it 'creates a new user' do 

			post '/api/v1/users', :params => {
				:user => {
					name: 'Colin Santee',
					email: 'colinsantee@email.com',
					password: 'iLoveCoffee',
				}
			}

			expect(response).to have_http_status(:success)
			expect(JSON.parse(response.body)['user']['name']).to eq('Colin Santee')
		end
	end

	describe 'PATCH /users' do 
		it 'updates an existing user' do
			user = FactoryBot.create(:user)

			patch "/api/v1/users/#{user.id}", :params => {
				:user => {
					name: 'Colin Santee',
				}
			}

			expect(response).to have_http_status(:success)
			expect(User.find(user.id)['name']).to eq('Colin Santee')
		end

		it 'updates user password with old password' do 
			user = FactoryBot.create(:user)
		end

		it 'wont update password without old password' do
			user = FactoryBot.create(:user)
		end

	end

end