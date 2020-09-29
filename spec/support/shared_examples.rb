RSpec.shared_examples 'a users resource' do
  context 'when a user is not signed in' do
    it 'redirects to the sign in page' do
      visit visiting_url

      expect(page). to have_current_path(new_user_session_path)
    end
  end
end
