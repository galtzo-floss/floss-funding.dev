# frozen_string_literal: true

require "omniauth-oauth2"

module OmniAuth
  module Strategies
    # Minimal OAuth2 strategy for GitLab (gitlab.com or self-hosted)
    class Gitlab < OmniAuth::Strategies::OAuth2
      option :name, "gitlab"

      option :client_options, {
        site: "https://gitlab.com",
        authorize_url: "/oauth/authorize",
        token_url: "/oauth/token"
      }

      option :scope, "read_user"

      uid { raw_info["id"].to_s }

      info do
        {
          name: raw_info["name"],
          email: raw_info["email"],
          nickname: raw_info["username"],
          image: raw_info["avatar_url"],
          urls: { profile: raw_info["web_url"] }
        }
      end

      extra do
        { raw_info: raw_info }
      end

      def raw_info
        @raw_info ||= access_token.get("/api/v4/user").parsed || {}
      end
    end
  end
end
