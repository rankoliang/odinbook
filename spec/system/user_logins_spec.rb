require 'rails_helper'

RSpec.describe 'UserLogins', type: :system do
  before do
    driven_by(:rack_test)
  end

  context 'user is not signed in' do
    it 'has a sign in button' do
      visit root_url
      expect(page).to have_button('Sign in')
      expect(page).to have_button('Sign up')
    end
  end
end
