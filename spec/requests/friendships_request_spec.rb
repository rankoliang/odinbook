require 'rails_helper'

RSpec.describe 'Friendships', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  describe 'GET friendships#index' do
    context 'when not logged in' do
      it 'redirects to new user session path' do
        get user_friends_path(user)

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when logged in' do
      it 'returns http success' do
        sign_in user

        get user_friends_path(user)

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'DELETE friendships#destroy' do
    context 'when not logged in' do
      it 'redirects to new user session path' do
        delete user_remove_friend_path(user, other_user)

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when logged in' do
      it 'redirects back' do
        sign_in user
        user.add_friend(other_user)

        delete user_remove_friend_path(user, other_user)

        expect(response).to have_http_status(:redirect)
      end
    end

    context 'when logged in as another user' do
      it 'returns http unauthorized' do
        sign_in other_user
        delete user_remove_friend_path(user, other_user)

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
