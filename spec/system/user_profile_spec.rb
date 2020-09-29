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
    before do
      sign_in user
    end
    context 'when it visits their own profile' do
      it 'renders the user profile page' do
        visit user_url(user)

        expect(main).to have_content(user.name)
      end
    end
  end
end
