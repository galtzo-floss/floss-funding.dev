OmniAuth.config.logger = Rails.logger

# Enforce POST for /auth requests and add CSRF protection for OmniAuth
OmniAuth.config.allowed_request_methods = [:post]

# Load custom strategies
require "omniauth/strategies/codeberg"
require "omniauth/strategies/gitlab"

Rails.application.config.middleware.use(OmniAuth::Builder) do
  # Password identity
  provider :identity,
    fields: [:email],
    model: Identity,
    on_failed_registration: lambda { |env|
      SessionsController.action(:new).call(env)
    }

  # GitHub OAuth
  if ENV["GITHUB_CLIENT_ID"].present? && ENV["GITHUB_CLIENT_SECRET"].present?
    provider :github,
      ENV["GITHUB_CLIENT_ID"],
      ENV["GITHUB_CLIENT_SECRET"],
      scope: "user:email",
      provider_ignores_state: false
  end

  # GitLab OAuth
  if ENV["GITLAB_CLIENT_ID"].present? && ENV["GITLAB_CLIENT_SECRET"].present?
    gitlab_site = ENV["GITLAB_SITE"].presence || "https://gitlab.com"
    provider :gitlab,
      ENV["GITLAB_CLIENT_ID"],
      ENV["GITLAB_CLIENT_SECRET"],
      client_options: { site: gitlab_site },
      scope: "read_user",
      provider_ignores_state: false
  end

  # Codeberg OAuth (custom strategy)
  if ENV["CODEBERG_CLIENT_ID"].present? && ENV["CODEBERG_CLIENT_SECRET"].present?
    provider :codeberg,
      ENV["CODEBERG_CLIENT_ID"],
      ENV["CODEBERG_CLIENT_SECRET"],
      scope: "read:user",
      client_options: {
        site: ENV["CODEBERG_SITE"].presence || "https://codeberg.org"
      },
      provider_ignores_state: false
  end
end
