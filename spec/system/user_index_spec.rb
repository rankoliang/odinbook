require 'rails_helper'

RSpec.describe 'UserIndex', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:users) { FactoryBot.create_list(:user, 100) }
  let(:visiting_url) { users_path }

  it_behaves_like 'a users resource'

  context 'when a user is signed in' do
    it 'renders other users' do
      sign_in users.first

      visit visiting_url

      expect(page).to have_current_path(users_path)
      expect(page).to have_button('Add friend', maximum: 10)
      expect(page).to have_css('.list-group-item', count: 10)
    end
  end
end
