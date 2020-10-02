require 'rails_helper'

RSpec.describe 'HeaderElements', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'has navigation links' do
    visit root_url

    expect(header).to have_link 'Odinbook', href: root_path
    expect(header).to have_link 'Find Friends', href: users_path
  end

  context 'when a user is not signed in' do
    before do
      visit root_url
    end

    it 'has a registration link' do
      expect(header).to have_link 'Sign up', href: new_user_registration_path
    end

    it 'has a sign in link' do
      expect(header).to have_link 'Sign in', href: new_user_session_path
    end

    it 'does not have a sign out link' do
      expect(header).to have_no_link 'Sign out'
    end
  end

  context 'when a user is signed in' do
    before do
      sign_in user

      visit root_url
    end

    let(:user) { FactoryBot.create(:user) }

    it 'has a sign out link' do
      expect(header).to have_link 'Sign out', href: destroy_user_session_path
    end

    it 'has a profile link' do
      expect(header).to have_link href: user_path(user)
    end

    it 'has an update profile link' do
      expect(header).to have_link href: edit_user_path(user)
    end

    it 'has a manage account link' do
      expect(header).to have_link href: edit_user_registration_path
    end

    it 'does not have a registration link' do
      expect(header).to have_no_link 'Sign up', href: new_user_registration_path
    end

    it 'does not have a sign in link' do
      expect(header).to have_no_link 'Sign in', href: new_user_session_path
    end
  end
end
