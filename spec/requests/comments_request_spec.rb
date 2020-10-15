require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  include_context 'users'
  let(:user_post) { user.post(Faker::Lorem.paragraph) }
  let(:comment) { user.comment(user_post, Faker::Lorem.paragraph) }

  describe 'POST /post/:post_id/comment/:id' do
    context 'when not logged in' do
      it 'redirects to new user session path' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when logged in' do
      it 'redirects the user' do
        sign_in user
        post post_comments_path(user_post), params: { comment: { content: Faker::Lorem.paragraph } }

        expect(response).not_to redirect_to new_user_session_path
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe 'DELETE /post/:post_id/comment/:id' do
    context 'when not logged in' do
      it 'redirects to a new user session path' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when logged in' do
      it 'redirects the user' do
        sign_in user
        delete post_comment_path(user_post, comment)

        expect(response).not_to redirect_to new_user_session_path
        expect(response).to have_http_status(:redirect)
      end
    end

    context 'when logged in as another user' do
      it 'returns http unauthorized' do
        sign_in other_user
        delete post_comment_path(user_post, comment)

        expect(response).to return_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /post/:post_id/comment/:id/edit' do
    context 'when not logged in' do
      it 'redirects to a new user session path' do
        get edit_post_comment_path(user_post, comment)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when logged in' do
      it 'redirects the user' do
        sign_in user
        get edit_post_comment_path(user_post, comment)

        expect(response).not_to redirect_to new_user_session_path
        expect(response).to have_http_status(:redirect)
      end
    end

    context 'when logged in as another user' do
      it 'returns http unauthorized' do
        sign_in other_user
        get edit_post_comment_path(user_post, comment)

        expect(response).to return_http_status(:unauthorized)
      end
    end
  end

  describe 'patch /post/:post_id/comment/:id' do
    context 'when not logged in' do
      it 'redirects to a new user session path' do
        patch post_comment_path(user_post, comment), params: { comment: { content: Faker::Lorem.paragraph } }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when logged in' do
      it 'redirects the user' do
        sign_in user
        patch post_comment_path(user_post, comment), params: { comment: { content: Faker::Lorem.paragraph } }

        expect(response).not_to redirect_to new_user_session_path
        expect(response).to have_http_status(:redirect)
      end
    end

    context 'when logged in as another user' do
      it 'returns http unauthorized' do
        sign_in other_user
        patch post_comment_path(user_post, comment), params: { comment: { content: Faker::Lorem.paragraph } }

        expect(response).to return_http_status(:unauthorized)
      end
    end
  end
end
