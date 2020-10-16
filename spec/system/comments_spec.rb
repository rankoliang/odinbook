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
    let(:comment_content) { Faker::Lorem.paragraph }
    let(:updated_comment_content) { Faker::Lorem.paragraph }

    it 'can create a comment' do
      click_on 'Comment'

      within find('form.comment_form') do
        fill_in 'Comment', with: comment_content
        click_button 'Post'
      end

      expect(page).to have_content comment_content
    end

    xit 'can edit and update a comment' do
      comment = user.comment(user_post, comment_content)

      visit posts_path
      within comment_element_for(comment) do
        click_on 'Edit'
      end

      fill_in 'Comment', with: updated_comment_content
      click_button 'Edit comment'

      expect(page).to have_content updated_comment_content
    end

    xit 'can delete a comment' do
      comment = user.comment(user_post, comment_content)

      visit posts_path
      within comment_element_for(comment) do
        click_on 'Delete'
      end

      expect(page).to have_no_content comment_content
    end
  end

  context 'when not logged in' do
    before do
      user_post
      other_user.add_friend(user)
      sign_in other_user
      visit posts_path
    end

    let(:user_post) { user.post(Faker::Lorem.paragraph) }
    let(:comment_content) { Faker::Lorem.paragraph }
    let(:updated_comment_content) { Faker::Lorem.paragraph }

    xit 'cannot edit and update a comment' do
      comment = user.comment(user_post, comment_content)

      visit posts_path
      expect(comment_element_for(comment)).to have_no_content 'Edit'
    end

    xit 'can delete a comment' do
      comment = user.comment(user_post, comment_content)

      visit posts_path
      expect(comment_element_for(comment)).to have_no_content 'Delete'
    end
  end
end
