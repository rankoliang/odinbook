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
      user.request_to_be_friends(other_user)
      visit sent_requests_path
    end

    it 'shows sent requests' do
      expect(main).to have_content other_user.name
    end

    it 'has a button to cancel the request' do
      expect(main).to have_button 'Cancel request', id: other_user.id
    end

    context 'when the cancel button is clicked' do
      it 'destroys the request' do
        expect { click_on 'Cancel request' }
          .to change {user.requestees.count}.by(-1)
      end
    end
  end
end
