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

    context 'when not logged in' do
      it 'redirects to new user session path' do
        sign_in user

        get user_friends_path(user)

        expect(response).to have_http_status(:success)
      end
    end
  end
end
