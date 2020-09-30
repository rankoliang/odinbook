require 'rails_helper'

RSpec.describe 'UserProfile', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) { FactoryBot.create(:user) }

  it_behaves_like 'a users resource' do
    let(:visiting_url) { user_url(user) }
  end

  context 'when a user is signed in' do
    context 'when a user visits their own profile' do
      before do
        sign_in user
        visit user_url(user)
      end
      let(:profile) { find('.profile') }
      it 'renders their display name' do
        expect(profile).to have_content(user.name)
      end

      it 'renders their summary' do
        expect(profile).to have_content(user.summary)
      end

      it 'renders their profile picture' do
        expect(profile).to have_selector 'img'
      end
    end
  end
end
