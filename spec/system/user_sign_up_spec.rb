require 'rails_helper'

RSpec.describe 'UserSignUp', type: :system do
  before do
    driven_by(:rack_test)
  end

  context 'when a new user signs up' do
    it 'redirects to the homepage' do
      visit root_path

      click_button 'Sign up'

      password = 'foobar'

      fill_in 'Email', with: 'jsmith@example.com'
      fill_in 'Display name', with: 'jsmith'
      fill_in 'Password', with: password
      fill_in 'Password confirmation', with: password

      click_button 'Sign up'
      expect(page).to have_current_path(root_path)
      expect(page).to have_content('email')
    end
  end

  context "when validations don't pass" do
    it 'does not redirect to the homepage' do
      visit root_path

      click_button 'Sign up'

      fill_in 'Email', with: ''
      fill_in 'Password', with: 'foobar'
      fill_in 'Password confirmation', with: 'hunter2'

      click_button 'Sign up'

      expect(page).to_not have_current_path(root_path)
    end
  end
end
