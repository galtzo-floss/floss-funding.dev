Rails.application.config.middleware.use OmniAuth::Builder do
  provider :identity,
           fields: [:email],
           model: Identity,
           on_failed_registration: lambda { |env|
             SessionsController.action(:new).call(env)
           }
end

OmniAuth.config.logger = Rails.logger
