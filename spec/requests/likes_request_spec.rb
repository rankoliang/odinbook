require 'rails_helper'

RSpec.describe "Likes", type: :request do
  include_context 'users'
  subject(:user_post) { user.posts.create(content: Faker::Lorem.paragraph) }

  describe 'when liking a post' do
    context 'when not logged in' do
      it 'redirects to new user session path' do
        post post_like_path(user_post)

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when logged in' do
      it 'does not redirect to new user session path' do
        sign_in user

        post post_like_path(user_post)

        expect(response).not_to redirect_to new_user_session_path
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe 'when unliking a post' do
    context 'when not logged in' do
      it 'redirects to new user session path' do
        delete post_like_path(user_post)

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when logged in' do
      it 'does not redirect to new user session path' do
        sign_in user

        delete post_like_path(user_post)

        expect(response).to redirect_to posts_path
        expect(response).to have_http_status(:redirect)
      end
    end
  end
end
