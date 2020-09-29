require 'rails_helper'

RSpec.describe 'UserIndex', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:users) { FactoryBot.create_list(:user, 100) }

  it_behaves_like 'a users resource' do
    let(:visiting_url) { users_path }
  end

  context 'when a user is signed in' do
    before do
      sign_in users.first
    end

    it 'renders other users' do
      visit users_path

      expect(page).to have_current_path(users_path)
      expect(main).to have_button('Add friend', maximum: 10)
      expect(main).to have_css('.list-group-item', count: 10)
    end
  end
end
