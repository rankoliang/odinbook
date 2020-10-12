require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  include_context 'users'
  subject(:user_post) { user.posts.build(content: Faker::Lorem.paragraph) }
  let(:updated_post) { user.posts.build(content: Faker::Lorem.paragraph) }

  describe 'GET posts#index' do
    context 'when not logged in' do
      xit 'redirects to new user session path' do
        get posts_path(user)

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when logged in' do
      xit 'returns http success' do
        sign_in user

        get posts_path(user)

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'creates a new post' do
    context 'when not logged in' do
      xit 'redirects to new user session path' do
        post posts_path(user), params: { post: { content: user_post.content } }

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when logged in' do
      xit 'redirects to the index path' do
        post posts_path(user), params: { post: { content: user_post.content } }

        expect(response).to redirect_to posts_path(user)
      end
    end
  end

  describe 'edits a post' do
    before do
      user_post.save
    end

    context 'when not logged in' do
      xit 'redirects to new user session path' do
        get edit_post_path(user, user_post)

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when logged in' do
      xit 'returns http success' do
        sign_in user
        get edit_post_path(user, user_post)

        expect(response).to have_http_status(:success)
      end
    end

    context 'when logged in as another user' do
      xit 'returns http unauthorized' do
        sign_in other_user
        get edit_post_path(user, user_post)

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'updates a post' do
    before do
      user_post.save
    end

    context 'when not logged in' do
      xit 'redirects to new user session path' do
        patch post_path(user, user_post), params: { post: { content: updated_post.content } }

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when logged in' do
      xit 'returns http success' do
        sign_in user
        patch post_path(user, user_post), params: { post: { content: updated_post.content } }

        expect(response).to have_http_status(:success)
      end
    end

    context 'when logged in as another user' do
      xit 'returns http unauthorized' do
        sign_in other_user
        patch post_path(user, user_post), params: { post: { content: updated_post.content } }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'deletes a post' do
    before do
      user_post.save
    end

    context 'when not logged in' do
      xit 'redirects to new user session path' do
        delete post_path(user, user_post)

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when logged in' do
      xit 'redirects after success' do
        sign_in(user)
        delete post_path(user, user_post)

        expect(response).to have_http_status(:redirect)
      end
    end

    context 'when logged in as a different user' do
      xit 'returns http status unauthorized' do
        sign_in(other_user)
        delete post_path(user_post)

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
