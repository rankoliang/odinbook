require 'rails_helper'

RSpec.describe 'UserProfile', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) { FactoryBot.create(:user) }
  let(:visiting_url) { user_url(user) }

  it_behaves_like 'a users resource'
end
