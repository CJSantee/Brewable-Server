require 'rails_helper'

RSpec.describe 'Api::V1::Permissions', type: :request do
	
	before(:all) do 
		@test_user = FactoryBot.create(:user)
		@role = Role.create(name: 'Jester')
		Assignment.create(user_id: @test_user.id, role_id: @role.id)
		@permission_value = 'jokes:get'
		@permission = Permission.create(role_id: @role.id, permission: @permission_value)
	end

	before(:each) do 
		@user = User.find(1)
		payload = { user_id: @user.id }
		token = JWT.encode(payload, ENV['SECRET_KEY_BASE'] || Rails.application.secrets.secret_key_base)
		cookies[:jwt] = token
	end

	describe 'GET /api/v1/users/:id/permissions' do
		it 'Gets all permissions for a user :id' do 
			get "/api/v1/users/#{@test_user.id}/permissions"

			expect(response).to have_http_status(:success)
			body = JSON.parse(response.body)
			expect(body.count).to eq(1)
			expect(body[0]).to eq(@permission_value)
		end
	end

	describe 'GET /api/v1/roles/:id/permissions' do
		it 'Gets all permissions for a role' do 
			get "/api/v1/roles/#{@role.id}/permissions"
			
			expect(response).to have_http_status(:success)
			body = JSON.parse(response.body)
			expect(body.count).to eq(1)
			expect(body[0]).to eq(@permission_value)
		end
	end

	describe 'POST /api/v1/roles/:id/permissions' do 
		it 'Creates a new permission for a role' do 
			post "/api/v1/roles/#{@role.id}/permissions", :params => {
				:permissions => [
					'jokes:post',
					'jokes:delete',
				]
			}

			expect(@role.permissions.count).to eq(3)
			permissions = @role.permissions.map do |permissionObj|
				permissionObj.permission
			end
			expect(permissions.include?('jokes:post')).to eq(true)
		end
	end

end