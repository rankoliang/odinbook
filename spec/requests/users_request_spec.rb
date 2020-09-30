require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  describe 'GET /index' do
    context 'when not logged in' do
      it 'redirects to new user session path' do
        get '/users/index'

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when logged in' do
      it 'returns http success' do
        sign_in user
        get '/users/index'

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET /users/:id' do
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

  describe 'PATCH users#update' do
    let(:user_params) do
      { id: user.id, user: { name: 'John Smith', summary: Faker::Lorem.paragraph}}
    end

    context 'when not logged in' do
      it 'redirects to new user session path' do
        patch user_path(user), params: user_params

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when logged in as self' do
      it 'returns http success' do
        sign_in user

        patch user_path(user), params: user_params

        expect(response).to redirect_to user
      end
    end

    context 'when logged in as another user' do
      it 'returns http unauthorized' do
        sign_in other_user

        patch user_path(user), params: user_params

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
