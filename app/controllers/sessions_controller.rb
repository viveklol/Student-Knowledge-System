class SessionsController < ApplicationController
  def create

    email = request.env['omniauth.auth']['info']['email']

    # If the authentication was successful, meaning the email was found in the omniauth's return, create a new session
    if email

      user = User.find_by(email: email)
      
      if user.nil?
        redirect_to new_user_path, alert: 'Create an account before signing in with Google'
      else
        session = Passwordless::Session.new({
            authenticatable: user,
            user_agent: 'Command Line',
            remote_addr: 'unknown',
        })
        session.save!
        @magic_link = send(Passwordless.mounted_as).token_sign_in_url(session.token)
        
        redirect_to @magic_link
      end
    else
      redirect_to users.sign_in_path, alert: 'Failed to authenticate with Google'
    end
  end
end

