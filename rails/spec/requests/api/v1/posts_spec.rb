require 'rails_helper'

RSpec.describe 'Api::V1::Posts', type: :request do
	
	before(:each) do 
		@user = User.find(1)
		payload = { user_id: @user.id }
		token = JWT.encode(payload, ENV['SECRET_KEY_BASE'] || Rails.application.secrets.secret_key_base)
		cookies[:jwt] = token
	end

	describe 'GET /api/v1/posts' do 
		it 'Gets all the most recent posts' do 
			FactoryBot.create_list(:post, 15)

			get '/api/v1/posts'

			expect(response).to have_http_status(:success)
			expect(JSON.parse(response.body).count).to eq(15)
		end
	end

	describe 'GET /api/v1/users/:id/posts' do 
		it 'Gets all the posts from a specific user' do 
			user = FactoryBot.create(:user)
			FactoryBot.create_list(:post, 15, user_id: user.id) # User posts
			FactoryBot.create_list(:post, 5) # Other posts

			get "/api/v1/users/#{user.id}/posts"

			expect(response).to have_http_status(:success)
			expect(JSON.parse(response.body).count).to eq(15)
		end	
 	end

	describe 'GET /api/v1/users/:id/posts/:id' do 
		it 'Gets a specific post' do 
			post = FactoryBot.create(:post)

			get "/api/v1/users/#{post.user.id}/posts/#{post.id}"

			expect(response).to have_http_status(:success)
			expect(JSON.parse(response.body)).to include('id', 'caption')
			expect(JSON.parse(response.body)['caption']).to eq(post.caption)
		end
	end

	describe 'GET /api/v1/users/:id/feed' do 
		it 'Gets all the most recent posts for users this user is following' do 
			user = FactoryBot.create(:user)
			followed_user_1 = FactoryBot.create(:user)
			followed_user_2 = FactoryBot.create(:user)
			
			Follow.create(follower_id: user.id, followed_id: followed_user_1.id)
			Follow.create(follower_id: user.id, followed_id: followed_user_2.id)

			FactoryBot.create_list(:post, 5, user_id: followed_user_1.id)
			FactoryBot.create_list(:post, 5, user_id: followed_user_2.id)
			FactoryBot.create_list(:post, 15) # Other Posts

			get "/api/v1/users/#{user.id}/feed"

			expect(response).to have_http_status(:success)
			expect(JSON.parse(response.body).count).to eq(10)
		end
	end

	describe 'POST /api/v1/users/:id/posts' do 
		it 'Create a post for a user' do 
			user = FactoryBot.create(:user)

			post "/api/v1/users/#{user.id}/posts", :params => {
				:post => {
					caption: 'This is my first post!',
				}
			}

			expect(response).to have_http_status(:success)
			expect(user.posts.count).to eq(1)
		end
	end	

	describe 'PATCH /api/v1/users/:id/posts/:id' do 
		it 'Updates a post from a user' do 
			user = FactoryBot.create(:user)
			post = FactoryBot.create(:post, user_id: user.id)

			patch "/api/v1/users/#{user.id}/posts/#{post.id}", :params => {
				:post => {
					caption: 'This is an edited post!',
				}
			}

			expect(response).to have_http_status(:success)
			updated = Post.find(post.id)
			expect(updated.caption).to eq('This is an edited post!')
			expect(updated.created_at == updated.updated_at).to eq(false)
		end
	end

	describe 'PATCH /api/v1/users/:id/posts/:id' do 
		it 'Archives a post from a user' do 
			post = FactoryBot.create(:post)

			delete "/api/v1/users/#{post.user.id}/posts/#{post.id}"

			expect(response).to have_http_status(:success)
			expect(Post.find(post.id).archived_at).not_to eq(nil)
		end
	end

end