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

  let(:friend) do
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
      expect {user.request_to_be_friends(friend)}
        .to change { user.sent_requests.count }.by 1
    end
  end

  describe '#friend_request_from' do
    context 'when the request exists' do
      it 'returns a request' do
        friend.request_to_be_friends(user)

        expect(user.friend_request_from(friend)).to be_truthy
      end
    end

    context 'when the request does not exist' do
      it 'returns nil' do
        expect(user.friend_request_from(friend)).to be_nil
      end
    end
  end

  describe '#accept_friend_request_from' do
    before do
      friend.request_to_be_friends(user)
    end

    it 'destroys the request' do
      expect {  user.accept_friend_request_from(friend) }
        .to change { user.friend_requests.count }.by(-1)
    end

    it 'creates a new friend for the user' do
      expect { user.accept_friend_request_from(friend) }
        .to change { user.friends.count }.by 1
    end

    it 'creates a new friend for the other user' do
      expect { user.accept_friend_request_from(friend) }
        .to change { friend.friends.count }.by 1
    end
  end
end
# rubocop:enable Metrics/BlockLength
