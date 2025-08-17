# frozen_string_literal: true

require "omniauth-oauth2"

module OmniAuth
  module Strategies
    # Minimal OAuth2 strategy for Codeberg (Forgejo/Gitea)
    # Docs: https://codeberg.org/Codeberg/Community/src/branch/main/content/technical/oauth2.md (general OAuth2)
    class Codeberg < OmniAuth::Strategies::OAuth2
      option :name, "codeberg"

      option :client_options, {
        site: "https://codeberg.org",
        authorize_url: "/login/oauth/authorize",
        token_url: "/login/oauth/access_token",
      }

      # Request basic user scope to access profile email if available
      option :scope, "read:user"

      uid { raw_info["id"].to_s }

      info do
        {
          name: raw_info["full_name"].presence || raw_info["login"],
          email: primary_email_from_api,
          nickname: raw_info["login"],
          image: raw_info["avatar_url"],
          urls: {
            profile: raw_info["html_url"] || "https://codeberg.org/#{raw_info["login"]}",
          },
        }
      end

      extra do
        {raw_info: raw_info}
      end

      def raw_info
        @raw_info ||= access_token.get("/api/v1/user").parsed || {}
      end

      # Attempt to fetch emails; requires the token to permit it.
      def primary_email_from_api
        emails = access_token.get("/api/v1/user/emails").parsed
        # Find primary and verified if available
        primary = emails.find { |e| e["primary"] } || emails.find { |e| e["verified"] }
        (primary && primary["email"]) || nil
      rescue StandardError
        nil
      end
    end
  end
end
