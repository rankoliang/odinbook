require 'rails_helper'

RSpec.describe 'FriendRequests', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  describe 'GET friendships#sent_requests' do
    context 'when not logged in' do
      it 'redirects to new user session path' do
        get sent_requests_path

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when logged in' do
      it 'redirects to the user index' do
        sign_in user

        get sent_requests_path

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'POST friendships#create' do
    context 'when not logged in' do
      it 'redirects to new user session path' do
        post add_friend_path, params: { requestee_id: other_user.id }

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when logged in' do
      it 'redirects the user' do
        sign_in user

        post add_friend_path, params: { requestee_id: other_user.id }

        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe 'DELETE friendships#destroy' do
    context 'when not logged in' do
      it 'redirects to new user session path' do
        post cancel_request_path, params: { requestee_id: other_user.id }

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when logged in' do
      it 'redirects the user' do
        sign_in user

        post cancel_request_path, params: { requestee_id: other_user.id }

        expect(response).to have_http_status(:redirect)
      end
    end
  end
end
