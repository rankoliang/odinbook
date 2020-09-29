require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { FactoryBot.create(:user) }
  it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:name) }

  describe '.from_omniauth' do
    context 'when a user exists in the database' do
      subject(:user) { FactoryBot.create(:user, :from_discord) }

      it 'finds the user' do
        info = double('Info', email: user.email, name: user.name)
        auth = double('Auth', provider: user.provider, uid: user.uid, info: info)

        expect(described_class.from_omniauth(auth)).to eq(user)
      end
    end

    context 'when a user does not exist in the database' do
      subject(:user) { FactoryBot.build(:user, :from_discord) }

      it 'creates the user' do
        info = double('Info', email: user.email, name: user.name)
        auth = double('Auth', provider: user.provider, uid: user.uid, info: info)

        expect { described_class.from_omniauth(auth) }.to change { described_class.count }.by(1)
      end
    end
  end
end
