require 'rails_helper'

RSpec.describe 'Notifications', js: true, type: :system do
  before do
    driven_by :selenium

    sign_in user
    visit root_path
  end

  include_context 'users'

  context 'when a user has no pending requests' do
    it 'has no notifications' do
      within header do
        click_button class: 'navbar-toggler' if has_button? class: 'navbar-toggler'
        click_on id: 'notification-dropdown'
      end
      expect(header).to have_content 'No notifications'
    end
  end

  context 'when a user has pending requests' do
    before do
      other_user.request_to_be_friends user
      visit root_path
      within header do
        click_button class: 'navbar-toggler' if has_button? class: 'navbar-toggler'
        click_on id: 'notification-dropdown'
      end
    end

    it 'can interact with the request' do
      expect(header).to have_link other_user.name, href: user_path(other_user)
      expect(header).to have_button 'Accept'
      expect(header).to have_button 'Reject'
    end
  end
end
