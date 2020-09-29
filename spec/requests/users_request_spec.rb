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
      let(:user) { FactoryBot.create(:user) }
      it 'returns http success' do
        sign_in user
        get '/users/index'
        expect(response).to have_http_status(:success)
      end
    end
  end
end
