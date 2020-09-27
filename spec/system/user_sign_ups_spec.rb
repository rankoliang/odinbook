require 'rails_helper'

RSpec.describe 'UserSignUps', type: :system do
  before do
    driven_by(:rack_test)
  end

  context 'when a new user signs up' do
    it 'redirects to the homepage' do
      visit root_path

      click_on 'Sign up'

      password = 'foobar'

      fill_in 'Email', with: 'jsmith@example.com'
      fill_in 'Password', with: 'jsmith@example.com'
      fill_in 'Password confirmation', with: 'jsmith@example.com'

      click_on 'Sign up'
      expect(page).to have_current_path(root_path)
      expect(page).to have_content('email')
    end
  end
end
