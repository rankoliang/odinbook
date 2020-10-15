require 'rails_helper'

RSpec.describe 'Comments', type: :system do
  before do
    driven_by(:selenium)
  end

  include_context 'users'

  context 'when logged in' do
    before do
      user_post
      sign_in user
      visit posts_path
    end

    let(:user_post) { user.post(Faker::Lorem.paragraph) }

    it 'can create a comment' do
      click_on 'Comment'

      comment = Faker::Lorem.paragraph
      fill_in 'Comment', with: comment
      click_button 'Submit comment'

      expect(page).to have_content comment
    end
  end
end
