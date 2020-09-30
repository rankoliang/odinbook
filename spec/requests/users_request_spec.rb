require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /index' do
    context 'when not logged in' do
      it 'redirects to new user session path' do
        get '/users/index'
        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'when logged in' do
      before do
        sign_in FactoryBot.create(:user)
      end
      it 'returns http success' do
        get '/users/index'

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET /users/:id' do
    let(:user) { FactoryBot.create(:user) }

    context 'when not logged in' do
      it 'redirects to new user session path' do
        get user_path(user)

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when logged in' do
      it 'returns http success' do
        sign_in user

        get user_path(user)

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET /users/:id/edit' do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }

    context 'when not logged in' do
      it 'redirects to new user session path' do
        get edit_user_path(user)

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when logged in as self' do
      it 'returns http success' do
        sign_in user

        get edit_user_path(user)

        expect(response).to have_http_status(:success)
      end
    end

    context 'when logged in as another user' do
      it 'returns http unauthorized' do
        sign_in other_user

        get edit_user_path(user)

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
