require 'rails_helper'

RSpec.describe 'UserLogin', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) { FactoryBot.create(:user) }

  context 'when the user is not signed in' do
    it 'can create a new user or session' do
      visit root_url

      expect(main).to have_button 'Sign in'
      expect(main).to have_button 'Sign up'
    end
  end

  context 'when the user is signed in' do
    context 'when using the log in form' do
      before do
        visit new_user_session_url

        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_button 'Log in'
      end

      it 'cannot create a new user or session' do
        expect(main).to have_no_content 'Sign in'
        expect(main).to have_no_content 'Sign up'
      end

      it 'redirects to their profile' do
        expect(page).to have_current_path user_path(user)
      end
    end

    it 'can destroy a session' do
      sign_in user
      visit root_url

      click_link 'Sign out'

      expect(main).to have_css '.alert'
    end
  end
end
