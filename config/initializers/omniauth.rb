Rails.application.config.middleware.use OmniAuth::Builder do
    provider :google_oauth2, Rails.application.credentials[:GOOGLE_CLIENT_ID], Rails.application.credentials[:GOOGLE_CLIENT_SECRET], {
        provider_ignores_state: false,
        prompt: 'select_account',
        image_aspect_ratio: 'square',
        image_size: 200,
        scope: 'email,profile,openid'
      }
end
OmniAuth.config.allowed_request_methods = [:get, :post]