require 'rails_helper'

RSpec.describe Post, type: :model do
  include_context 'users'

  subject(:post) { user.posts.create content: Faker::Lorem.paragraph }

  describe '#num_likes' do
    context 'when there are no likes' do
      it 'equals 0' do
        expect(post.num_likes).to eq 0
      end
    end

    context 'when there is one like' do
      it 'equals 1' do
        user.like(post)

        expect(post.num_likes).to eq 1
      end
    end
  end
end
