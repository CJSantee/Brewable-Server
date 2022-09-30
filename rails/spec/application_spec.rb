require 'rails_helper'

RSpec.describe 'Application', type: :request do

	before(:each) do 
		# Create User
		user = User.find(1)
		
		# Assign Admin Role
		admin = Role.find_by(name: 'admin')
		Assignment.create(user_id: user.id, role_id: admin.id)

		# Add JWT Cookie
		payload = { user_id: user.id }
		token = JWT.encode(payload, ENV['SECRET_KEY_BASE'] || Rails.application.secrets.secret_key_base)
		cookies[:jwt] = token
	end

	describe 'confirm_permission' do 
		it 'returns if permissions are granted' do 
			
			get '/api/v1/users'
			
			# Check response status
			expect(response).to have_http_status(:success)
		end

		it 'returns message if permissions are not granted' do
			FactoryBot.create_list(:user, 5)

			get '/forbidden'
			
			# Check response status
			expect(response).to have_http_status(:forbidden)
			# Check response message
			expect(JSON.parse(response.body)['message']).to eq('You do not have permission to access this resource.')
		end
	end

end