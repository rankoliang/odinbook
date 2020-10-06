RSpec.shared_examples 'a users resource' do
  context 'when a user is not signed in' do
    it 'redirects to the sign in page' do
      visit visiting_url

      expect(page). to have_current_path(new_user_session_path)
    end
  end
end
RSpec.shared_examples 'a users request' do
  context 'when not logged in' do
    it 'redirects to new user session path' do
      get visiting_path

      expect(response).to redirect_to new_user_session_path
    end
  end
end
