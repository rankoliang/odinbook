require 'rails_helper'

RSpec.describe 'UserIndex', type: :system do
  before do
    driven_by(:rack_test)
  end

  include_context 'users'

  it_behaves_like 'a users resource' do
    let(:visiting_url) { users_path }
  end

  context 'when a user is signed in' do
    before do
      sign_in user
      visit users_path
    end

    it 'renders the user index' do
      expect(page).to have_current_path(users_path)
    end

    it 'shows other users' do
      expect(main).to have_button('Add friend', maximum: 10)
      expect(main).to have_css('.list-group-item', count: 10)
    end

    it 'has links to user profile pages' do
      within '.list-group' do
        users = page.all('a')

        expect(users.count).to eq 10
      end
    end

    it 'has links to user profile pages' do
      within '.list-group' do
        users = page.all('img')

        expect(users.count).to eq 10
      end
    end

    context 'when a user adds another user' do
      it 'sends a friend request' do
        click_on 'Add friend', id: other_user.id

        expect(main).to have_content("A friend request to #{other_user.name} has been sent.")
      end
    end
  end
end
