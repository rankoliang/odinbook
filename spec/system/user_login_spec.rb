require 'rails_helper'

RSpec.describe 'UserLogin', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) { FactoryBot.create(:user) }

  context 'when the user is not signed in' do
    it 'can create a new user or session' do
      visit root_url

      expect(page).to have_button('Sign in')
      expect(page).to have_button('Sign up')
    end
  end

  context 'when the user is signed in' do
    it 'cannot create a new user or session' do
      visit new_user_session_url

      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Log in'

      expect(page).to have_link 'Sign out'
      expect(page).to have_no_button('Sign in')
      expect(page).to have_no_button('Sign up')
    end

    it 'can destroy a session' do
      sign_in user
      visit root_url

      click_link 'Sign out'

      expect(page).to have_css '.alert'
      expect(page).to have_no_link 'Sign out'
    end
  end
end
