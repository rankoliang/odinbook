require 'rails_helper'

RSpec.describe 'UserLogins', type: :system do
  before do
    driven_by(:rack_test)
  end

  context 'when the user is not signed in' do
    it 'has a sign in button' do
      visit root_url
      expect(page).to have_button('Sign in')
      expect(page).to have_button('Sign up')
    end
  end

  context 'when the user signs in' do
    xit 'does not have sign in buttons' do
      visit root_url
    end
  end
end
