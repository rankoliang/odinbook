require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe User, type: :model do
  subject(:user) do
    user = described_class.new(
      name: 'John Smith',
      email: 'jsmith@example.com',
      password: password,
      password_confirmation: password
    )
    user.skip_confirmation!
    user.save

    user
  end

  let(:password) { Devise.friendly_token }

  it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:summary).is_at_most(200) }
  it { is_expected.to validate_length_of(:name).is_at_most(26) }

  it { is_expected.to have_one_attached(:avatar) }
  it { is_expected.to have_many(:posts) }

  describe '.from_omniauth' do
    context 'when a user exists in the database' do
      subject(:user) { FactoryBot.create(:user, :from_discord) }

      it 'finds the user' do
        info = double('Info', email: user.email, name: user.name, image: nil)
        auth = double('Auth', provider: user.provider, uid: user.uid, info: info)

        expect(described_class.from_omniauth(auth)).to eq(user)
      end
    end

    context 'when a user does not exist in the database' do
      subject(:user) { FactoryBot.build(:user, :from_discord) }

      it 'creates the user' do
        info = double('Info', email: user.email, name: user.name, image: nil)
        auth = double('Auth', provider: user.provider, uid: user.uid, info: info)

        expect { described_class.from_omniauth(auth) }.to change { described_class.count }.by(1)
      end
    end
  end

  let(:other_user) do
    user = described_class.new(
      name: 'Jane Doe',
      email: 'jdoe@example.com',
      password: password,
      password_confirmation: password
    )
    user.skip_confirmation!
    user.save

    user
  end

  describe '#request_to_be_friends' do
    it 'creates a request' do
      expect { user.request_to_be_friends(other_user) }
        .to change { user.sent_requests.count }.by 1
    end
  end

  describe '#friend_request_from' do
    context 'when the request exists' do
      it 'returns a request' do
        other_user.request_to_be_friends(user)

        expect(user.friend_request_from(other_user)).to be_truthy
      end
    end

    context 'when the request does not exist' do
      it 'returns nil' do
        expect(user.friend_request_from(other_user)).to be_nil
      end
    end
  end

  describe '#accept_friend_request_from' do
    before do
      other_user.request_to_be_friends(user)
    end

    it 'destroys the request' do
      expect { user.accept_friend_request_from(other_user) }
        .to change { user.friend_requests.count }.by(-1)
    end

    it 'creates a new friend for the user' do
      expect { user.accept_friend_request_from(other_user) }
        .to change { user.friends.count }.by 1
    end

    it 'creates a new friend for the other user' do
      expect { user.accept_friend_request_from(other_user) }
        .to change { other_user.friends.count }.by 1
    end
  end

  describe '#cancel_request' do
    before do
      user.request_to_be_friends(other_user)
    end

    it 'destroys the request' do
      expect { user.cancel_request(other_user) }
        .to change { user.requestees.count }.by(-1)
    end
  end

  describe '#add_friend' do
    it 'adds a new friend' do
      expect { user.add_friend(other_user) }
        .to change { user.friends.count }.by(1) &
            change { other_user.friends.count }.by(1)
    end
  end

  describe '#remove_friend' do
    context 'the friend exists' do
      it 'removes a friend' do
        user.add_friend(other_user)

        expect { user.remove_friend(other_user) }
          .to change { user.friends.count }.by(-1) &
              change { other_user.friends.count }.by(-1)
      end
    end

    context 'the friend does not exist' do
      it 'does not remove a friend' do
        expect { user.remove_friend(other_user) }
          .not_to change { user.friends.count } ||
                  change { other_user.friends.count }
      end

      it 'returns nil' do
        expect(user.remove_friend(other_user)).to be_nil
      end
    end
  end

  describe '#relationship' do
    subject(:relationship) { user.relationship(other_user) }

    context 'when there is no relationship' do
      it 'returns nil' do
        expect(relationship).to be_nil
      end
    end

    context 'when the user is self' do
      it 'returns self' do
        expect(user.relationship(user)).to eq :self
      end
    end

    context 'when a request has been made' do
      it 'returns requestee' do
        user.request_to_be_friends(other_user)

        expect(relationship).to eq :requestee
      end
    end

    context 'when there is a pending request' do
      it 'returns requester' do
        other_user.request_to_be_friends(user)

        expect(relationship).to eq :requester
      end
    end

    context 'when the other user is a friend' do
      it 'returns friend' do
        user.add_friend(other_user)

        expect(relationship).to eq :friend
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
