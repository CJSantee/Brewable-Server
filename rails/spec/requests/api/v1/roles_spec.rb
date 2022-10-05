require 'rails_helper'

RSpec.describe 'Api::V1::Roles', type: :request do
	
	before(:all) do 
		@test_user = FactoryBot.create(:user)
		@role = Role.create(name: 'jester')
		Assignment.create(user_id: @test_user.id, role_id: @role.id)
	end

	before(:each) do 
		@user = User.find(1)
		payload = { user_id: @user.id }
		token = JWT.encode(payload, ENV['SECRET_KEY_BASE'] || Rails.application.secrets.secret_key_base)
		cookies[:jwt] = token
	end

	describe 'GET /api/v1/roles' do
		it 'Gets all available roles' do 
			get '/api/v1/roles'
			
			roles = Role.all.map do |role|
				role.name
			end

			expect(response).to have_http_status(:success)
			body = JSON.parse(response.body)
			expect(body.count).to eq(roles.count)
			expect(body.include?('jester')).to eq(true)
		end
	end

	describe 'GET /api/v1/roles/:id/users' do 
		it 'Gets all users with role :id' do 
			get "/api/v1/roles/#{@role.id}/users"

			expect(response).to have_http_status(:success)
			body = JSON.parse(response.body)
			expect(body.count).to eq(1)
			expect(body[0]['name']).to eq(@test_user.name)
		end
	end

	describe 'GET /api/v1/users/:id/roles' do 
		it 'Gets all roles assigned to user :id' do 
			get "/api/v1/users/#{@test_user.id}/roles"

			expect(response).to have_http_status(:success)
			body = JSON.parse(response.body)
			expect(body.include?('jester')).to eq(true)
		end
	end

	describe 'POST /api/v1/roles' do 
		it 'Creates a new role' do 
			post '/api/v1/roles', :params => {
				:role => {
					name: 'test',
				},
			}

			expect(response).to have_http_status(:success)
			roles = Role.all.map do |role| 
				role.name
			end
			expect(roles.include?('test')).to eq(true)
		end
	end

	describe 'POST /api/v1/users/:id/roles' do 
		it 'Assignes one or more roles to user :id' do 
			@new_role = Role.create(name: 'test')
			post "/api/v1/users/#{@test_user.id}/roles", :params => {
				:roles => [@new_role.id]
			}

			expect(response).to have_http_status(:success)
			roles = @test_user.roles.map do |role| 
				role.name
			end
			expect(roles.include?('test')).to eq(true)
		end
	end

end