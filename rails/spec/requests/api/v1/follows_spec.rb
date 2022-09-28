require 'rails_helper'

RSpec.describe 'Api::V1::Follows', type: :request do
	
	before(:each) do 
		@user = User.new(
			first_name: 'Test',
			last_name: 'User',
			email: 'brewableapp@gmail.com',
			password: 'iLoveCoffee',
		)
		@user.save
		payload = { user_id: @user.id }
		token = JWT.encode(payload, ENV['SECRET_KEY_BASE'] || Rails.application.secrets.secret_key_base)
		cookies[:jwt] = token
	end

	describe 'GET /users/:id/mutual' do
		it 'returns the users followed by @req_user and following :user_id' do 
			query_user = FactoryBot.create(:user)

			unique_followers = FactoryBot.create_list(:user, 15)
			mutual_followers = FactoryBot.create_list(:user, 5)

			unique_followers.each do |follower|
				follower.given_follows.create!(followed_id: query_user.id)
			end
			mutual_followers.each do |follower|
				follower.given_follows.create!(followed_id: query_user.id)
				@user.given_follows.create!(followed_id: follower.id)
			end

			get "/api/v1/users/#{query_user.id}/mutual"

			expect(response).to have_http_status(:success)
			expect(JSON.parse(response.body).size).to eq(5)
		end
	end

	describe 'GET /users/:id/follows' do 
		it 'returns count of mutual, followers, and following' do 
			query_user = FactoryBot.create(:user)

			unique_followers = FactoryBot.create_list(:user, 15)
			mutual_followers = FactoryBot.create_list(:user, 5)
			following = FactoryBot.create_list(:user, 25)

			unique_followers.each do |follower|
				follower.given_follows.create!(followed_id: query_user.id)
			end
			mutual_followers.each do |follower|
				follower.given_follows.create!(followed_id: query_user.id)
				@user.given_follows.create!(followed_id: follower.id)
			end
			following.each do |followed_user|
				query_user.given_follows.create!(followed_id: followed_user.id)
			end

			get "/api/v1/users/#{query_user.id}/follows"

			expect(response).to have_http_status(:success)
			body = JSON.parse(response.body)
			expect(body['mutual_count']).to eq(5)
			expect(body['followers_count']).to eq(20)
			expect(body['following_count']).to eq(25)
		end
	end

	describe 'GET /users/:id/followers' do 
		it 'returns all users following user :id' do 
			followed = FactoryBot.create(:user)
			followers = FactoryBot.create_list(:user, 15)
			followers.each do |follower|
				follower.given_follows.create!(followed_id: followed.id)
			end

			get "/api/v1/users/#{followed.id}/followers", :params => {
				limit: 5,
			}

			# Check response status
			expect(response).to have_http_status(:success)
			# Check pagination limit
			expect(JSON.parse(response.body).size).to eq(5)
			# Check total response size			
			expect(JSON.parse(response.headers['X-Pagination'])['total']).to eq(15)
		end
	end

	describe 'GET /users/:id/following' do 
		it 'returns all users followed by user :id' do 
			follower = FactoryBot.create(:user)
			following = FactoryBot.create_list(:user, 15)
			following.each do |user|
				follower.given_follows.create!(followed_id: user.id)
			end

			get "/api/v1/users/#{follower.id}/following", :params => {
				limit: 5,
			}

			# Check response status
			expect(response).to have_http_status(:success)
			# Check pagination limit
			expect(JSON.parse(response.body).size).to eq(5)
			# Check total response size
			expect(JSON.parse(response.headers['X-Pagination'])['total']).to eq(15)
		end
	end

	describe 'POST /users/:id/follow' do 
		it 'adds user :id as follower of followed_id' do
			follower = FactoryBot.create(:user)
			followed = FactoryBot.create(:user)

			post "/api/v1/users/#{follower.id}/follow", :params => {
				followed_id: followed.id,
			}

			# Check response status
			expect(response).to have_http_status(:success)
			# Check response attributes
			expect(JSON.parse(response.body)).to include('follower_id', 'followed_id')
			# Check update accuracy
			expect(User.find(follower.id).followers.count).to eq(0)
			expect(User.find(follower.id).following.count).to eq(1)
			expect(User.find(followed.id).followers.count).to eq(1)
			expect(User.find(followed.id).following.count).to eq(0)
		end
	end

end