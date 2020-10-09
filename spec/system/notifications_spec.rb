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
      toggle_notifications

      expect(header).to have_content 'No notifications'
      expect(header).to have_no_css '.text-warning'
    end
  end

  context 'when a user has pending requests' do
    before do
      other_user.request_to_be_friends user
      users[2].request_to_be_friends user
      visit root_path
      toggle_notifications
    end

    it 'can interact with the request' do
      expect(header).to have_css '.text-warning'
      expect(header).to have_link other_user.name, href: user_path(other_user)
      expect(header).to have_button 'Accept'
      expect(header).to have_button 'Reject'

      within header.find_by_id(other_user.id.to_s) do
        click_on 'Accept'
      end

      expect(page).to have_current_path root_path

      visit user_friends_path(user)

      expect(page).to have_content other_user.name

      toggle_notifications

      expect(header).to have_no_content other_user.name

      within header.find_by_id(users[2].id.to_s) do
        click_on 'Reject'
      end

      expect(page).to have_current_path user_friends_path(user)

      toggle_notifications

      expect(header).to have_no_content users[2].name
    end
  end
end

def toggle_notifications
  within header do
    click_button class: 'navbar-toggler' if has_button? class: 'navbar-toggler'
    click_on id: 'notification-dropdown'
  end
end
