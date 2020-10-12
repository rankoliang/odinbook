require 'rails_helper'

RSpec.describe 'Posts', type: :system do
  before do
    driven_by(:selenium)
  end

  let(:post_content) { 'This is a post.' }
  let(:updated_post_content) { 'I have edited my post.' }

  include_context 'users'

  context 'when logged in' do
    before do
      sign_in user
    end
    it 'can be created' do
      visit user_path(user)

      fill_in 'Share a post', with: post_content
      click_button 'Post'

      expect(main).to have_content post_content
    end

    it 'can edit a post' do
      post_to_be_edited = user.posts.create(content: post_content)
      visit user_path(user)

      within post_within_dom(post_to_be_edited) do
        click_on 'Edit'
      end

      fill_in 'Edit your post', with: updated_post_content
      click_button 'Repost'

      expect(main).to have_content updated_post_content
    end

    it 'can delete a post' do
      post_to_be_deleted = user.posts.create(content: post_content)
      visit user_path(user)

      within post_within_dom(post_to_be_deleted) do
        accept_confirm do
          click_on 'Delete'
        end
      end

      expect(main).to have_no_content post_content
    end
  end

  context 'when visiting the post index' do
    before do
      user.add_friend(friend)
      own_post
      friend_post
      stranger_post
      visit posts_path
    end

    let(:friend) { other_user }
    let(:stranger) { FactoryBot.create(:user) }
    let(:own_post) { user.posts.create(content: 'I am myself.') }
    let(:friend_post) { friend.posts.create(content: 'I am a friend.') }
    let(:stranger_post) { stranger.posts.create(content: 'I am a stranger.') }

    xit 'can see the content of their own posts' do
      expect(main).to have_content own_post.content
    end

    xit "can see the content of a friend's posts" do
      expect(main).to have_content friend_post.content
    end

    xit 'cannot see the content of a stranger' do
      expect(main).to have_no_content stranger_post.content
    end

    xit 'can delete only delete their own post' do
      expect(main).to have_content 'Delete', count: 1
      expect(post_within_dom(own_post)).to have_content 'Delete'
    end

    xit 'can only edit their own post' do
      expect(main).to have_content 'Edit', count: 1
      expect(post_within_dom(own_post)).to have_content 'Edit'
    end
  end
end
