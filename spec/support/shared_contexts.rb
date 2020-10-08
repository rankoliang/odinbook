RSpec.shared_context 'users' do
  subject(:user) { users.first }

  let(:users) { FactoryBot.create_list(:user, 30) }
  let(:other_user) { users[1] }
end
