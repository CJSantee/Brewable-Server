require 'rails_helper'

RSpec.describe 'Api::V1::Likes', type: :request do 
	
	before(:each) do 
		@user = User.find(1)
		payload = { user_id: @user.id }
		token = JWT.encode(payload, ENV['SECRET_KEY_BASE'] || Rails.application.secrets.secret_key_base)
		cookies[:jwt] = token
	end

	describe 'GET /api/v1/posts/:post_id/likes' do 
		it 'Gets all the users who have liked the post' do
			post = FactoryBot.create(:post)
			FactoryBot.create_list(:like, 15, post_id: post.id)

			get "/api/v1/posts/#{post.id}/likes"

			expect(response).to have_http_status(:success)
			expect(JSON.parse(response.body).count).to eq(15)
		end
	end

	describe 'POST /api/v1/posts/:post_id/likes' do
		it 'Likes a post as the logged in user' do 
			post = FactoryBot.create(:post)

			post "/api/v1/posts/#{post.id}/likes"

			expect(response).to have_http_status(:success)
			updated = Post.find(post.id)
			expect(updated.likes.count).to eq(1)
			expect(updated.likes.first.user_id).to eq(@user.id)
		end
		it 'Should like a post as the user defined in params, if provided' do 
			post = FactoryBot.create(:post)
			user = FactoryBot.create(:user)

			post "/api/v1/posts/#{post.id}/likes", :params => {
				user_id: user.id
			}

			expect(response).to have_http_status(:success)
			updated = Post.find(post.id)
			expect(updated.likes.count).to eq(1)
			expect(updated.likes.first.user_id).to eq(user.id)
		end
	end

	describe 'DELETE /api/v1/posts/:post_id/likes' do 
		it 'Removes a like from post' do 
			post = FactoryBot.create(:post)
			like = FactoryBot.create(:like, post_id: post.id, user_id: @user.id)

			delete "/api/v1/posts/#{post.id}/likes"

			expect(response).to have_http_status(:success)
			updated = Post.find(post.id)
			expect(updated.likes.count).to eq(0)
		end
		it 'Removes a like from post for specific user' do 
			post = FactoryBot.create(:post)
			like = FactoryBot.create(:like, post_id: post.id)
			user_id = like.user_id

			delete "/api/v1/posts/#{post.id}/likes", :params => {
				user_id: user_id
			}

			expect(response).to have_http_status(:success)
			updated = Post.find(post.id)
			expect(updated.likes.count).to eq(0)
		end
	end
end