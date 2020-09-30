require 'rails_helper'

RSpec.describe 'edit user profile', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) { FactoryBot.create(:user) }

  it_behaves_like 'a users resource' do
    let(:visiting_url) { edit_user_url(user) }
  end

  context 'when a user is logged in' do
    before do
      sign_in user
      visit edit_user_url(user)
    end

    it 'has a file input field' do
      user_edit_form = find('form')
      expect(user_edit_form).to have_css('input[type=file]')
    end

    context 'when the form is submitted' do
      let(:summary) { Faker::Lorem.paragraph }
      let(:name) { 'John Smith' }

      before do
        fill_in 'Display name', with: name
        fill_in 'Summary', with: summary

        click_button 'Update profile'
      end

      it 'redirects to the user profile' do
        expect(page).to have_current_path user_path(user)
      end

      it 'updates the user attributes' do
        profile = find('.profile')

        expect(profile).to have_content(name)
        expect(profile).to have_content(summary)
      end

      context 'When validations do not pass' do
        let(:summary) { Faker::Lorem.characters(number: 201) }

        it 'shows an error' do
          expect(main).to have_content 'error'
        end
      end
    end
  end
end
