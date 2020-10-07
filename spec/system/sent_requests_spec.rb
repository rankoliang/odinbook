require 'rails_helper'

RSpec.describe 'SentRequests', type: :system do
  before do
    driven_by(:rack_test)
  end

  subject(:user) { users.first }

  let(:users) { FactoryBot.create_list(:user, 10) }
  let(:other_user) { users[1] }

  describe 'when logged in' do
    before do
      sign_in user
    end

    it 'shows sent requests' do
      visit users_url
      click_on 'Add friend', id: other_user.id
      within header do
        click_on 'Sent Requests'
      end

      expect(main).to have_content other_user.name
    end
  end
end
