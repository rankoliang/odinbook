require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the PostsHelper. For example:
#
# describe PostsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe PostsHelper, type: :helper do
  include_context 'users'

  let(:post) { user.posts.create(content: Faker::Lorem.paragraph) }
  describe '#likes' do
    context 'when there is one like' do
      it 'returns 1 Like' do
        allow(post).to receive(:num_likes).and_return(1)
        expect(likes(post)).to eq '1 Like'
      end
    end

    context 'when there is not one like' do
      it 'returns 0 Likes' do
        allow(post).to receive(:num_likes).and_return(0)
        expect(likes(post)).to eq '0 Likes'
      end
    end
  end
end
