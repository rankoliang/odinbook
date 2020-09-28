require 'rails_helper'

RSpec.describe 'UserIndex', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:users) { FactoryBot.create_list(:user, 100) }

  context 'when a user is logged out' do
    it 'redirects to the sign in page' do
      visit users_path

      expect(page).to have_current_path(new_user_session_path)
    end
  end

  context 'when a user is signed in' do
    it 'sees other users' do
      sign_in users.first

      visit users_path

      expect(page).to have_current_path(users_path)
      expect(page).to have_button('Add friend', maximum: 10)
    end
  end
end
