require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'GET #create' do
    let(:user_email) { 'test@example.com' }

    context 'when authentication is successful' do
      before do
        OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
          provider: 'google_oauth2',
          uid: '123456',
          info: { email: user_email }
        })

        request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
      end

      it 'creates a new session and redirects to the magic link' do
        get :create
        expect(response.redirect_url).to include('/users/new')

      end
    end

    context 'when the user does not exist' do
      before do
        OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
          provider: 'google_oauth2',
          uid: '123456',
          info: { email: 'nonexistent@example.com' }
        })

        request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
      end

      it 'redirects to the new user path with an alert' do
        get :create

        expect(response).to redirect_to(new_user_path)
        expect(flash[:alert]).to eq('Create an account before signing in with Google')
      end
    end
  end
end
