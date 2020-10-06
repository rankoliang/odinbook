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

  let(:requests) { spy('requests') }

  let(:request) { spy('request') }

  before do
    allow(requests).to receive(:create)
    allow(request).to receive(:destroy)
  end

  describe '#request_to_be_friends' do
    it 'creates a request' do
      allow(user).to receive(:sent_requests).and_return(requests)

      user.request_to_be_friends(friend)

      expect(user.sent_requests).to have_received(:create)
    end
  end

  describe '#friend_request_from' do
    context 'when the request exists' do
      it 'returns a request' do
        allow(user).to receive(:friend_requests).and_return(requests)
        allow(requests).to receive(:find_by).with(requester: friend).and_return(request)

        friend.request_to_be_friends(user)

        expect(user.friend_request_from(friend)).to be request
      end
    end

    context 'when the request does not exist' do
      it 'returns nil' do
        allow(user).to receive(:friend_requests).and_return(requests)
        allow(requests).to receive(:find_by).with(requester: friend).and_return(nil)

        friend.request_to_be_friends(user)

        expect(user.friend_request_from(friend)).to be_nil
      end
    end
  end

  describe '#accept_friend_request_from' do
    before do
      allow(user).to receive(:friend_request_from).with(friend).and_return(request)

      friend.request_to_be_friends(user)
      user.accept_friend_request_from(friend)
    end

    it 'destroys the request' do
      expect(request).to have_received(:destroy)
    end

    xit 'creates a new friend' do
      expect(user.friends).to have_received(:create).with(friend: friend)
    end

    xit 'creates a new friend for the friend' do
      expect(friend.friends).to have_received(:create).with(friend: friend)
    end
  end
end
# rubocop:enable Metrics/BlockLength
