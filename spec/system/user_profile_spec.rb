require 'rails_helper'

RSpec.describe 'UserProfile', type: :system do
  before do
    driven_by :selenium
  end

  include_context 'users'

  it_behaves_like 'a users resource' do
    let(:visiting_url) { user_path(user) }
  end

  let(:profile) { find('.profile') }

  context 'when a user is signed in' do
    context 'when a user visits their own profile' do
      before do
        sign_in user
        visit user_path(user)
      end
      it 'renders their display name' do
        expect(profile).to have_content(user.name)
      end

      it 'renders their summary' do
        expect(profile).to have_content(user.summary)
      end

      it 'renders their profile picture' do
        expect(profile).to have_selector 'img'
      end

      it 'renders the number of friends' do
        expect(profile).to have_content pluralize(user.friends.count, 'friend')
      end

      it 'does not have an add friend button' do
        expect(profile).to have_no_button 'Add friend'
      end

      it 'does not have a remove friend button' do
        expect(profile).to have_no_button 'Add friend'
      end

      it 'does has an edit profile button' do
        expect(profile).to have_link href: edit_user_path(user)
      end

      it { expect(page).to have_button 'Post' }
    end

    context "when a user visits another user's profile" do
      before do
        sign_in user
        visit user_path(other_user)
      end

      context 'when the send request button is clicked' do
        it 'sends a friend request' do
          click_button 'Send request'

          expect(profile).to have_button 'Cancel request'
        end
      end

      context 'when the cancel request button is clicked' do
        it 'cancels the request' do
          user.request_to_be_friends(other_user)
          visit user_path other_user
          click_button 'Cancel request'

          expect(profile).to have_button 'Send request'
        end
      end

      context 'when the remove friend button is clicked' do
        it 'removes the friend' do
          other_user.add_friend(user)
          visit user_path other_user

          accept_confirm do
            click_button 'Remove friend'
          end

          expect(profile).to have_button 'Send request'
        end
      end

      context 'when there is a friend request pending' do
        context 'when the add friend button is clicked' do
          it 'adds the friend' do
            other_user.request_to_be_friends(user)
            visit user_path(other_user)

            click_button 'Add friend'

            expect(profile).to have_button 'Remove friend'
          end
        end
      end

      it { expect(profile).to have_no_link href: edit_user_path(other_user) }

      it { expect(page).to have_no_button 'Post' }
    end
  end
end
