require 'rails_helper'

RSpec.describe Friendship, type: :model do
  subject(:friendship) { described_class.new user: user, friend: friend }

  let(:user) { FactoryBot.create(:user) }
  let(:friend) { FactoryBot.create(:user) }

  context 'when created' do
    it 'should create the friendship in the opposite direction' do
      expect { friendship.save }
        .to change { described_class.count }.by 2
    end
  end

  context 'when destroyed' do
    it 'should create the friendship in the opposite direction' do
      friendship.save
      expect { friendship.destroy }
        .to change { described_class.count }.by(-2)
    end
  end

  describe '#matching' do
    before do
      friendship.save
    end

    it 'returns the matching entry' do
      expect(friendship.matching).to have_attributes user: friend, friend: user
    end
  end
end
