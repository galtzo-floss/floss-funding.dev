# frozen_string_literal: true

require "rails_helper"

RSpec.describe "OmniAuth callbacks", type: :request do
  include_context "with stubbed env"

  before do
    OmniAuth.config.test_mode = true
  end

  after do
    OmniAuth.config.test_mode = false
    OmniAuth.config.mock_auth[:github] = nil
  end

  it "signs in via GitHub and creates an account if needed" do
    mock_auth = OmniAuth::AuthHash.new(
      provider: "github",
      uid: "12345",
      info: { email: "dev@example.org", name: "Dev Example" }
    )
    OmniAuth.config.add_mock(:github, mock_auth)

    # Trigger callback
    get "/auth/github/callback", params: {}, headers: {}, env: {"omniauth.auth" => mock_auth}

    follow_redirect!

    expect(response).to have_http_status(:ok)
    expect(Account.find_by(email: "dev@example.org")).to be_present
    expect(session[:account_id]).to eq(Account.find_by(email: "dev@example.org").id)
  end

  it "fails gracefully when no email is provided" do
    mock_auth = OmniAuth::AuthHash.new(
      provider: "github",
      uid: "99999",
      info: { email: nil, name: "No Email" }
    )
    OmniAuth.config.add_mock(:github, mock_auth)

    get "/auth/github/callback", params: {}, headers: {}, env: {"omniauth.auth" => mock_auth}

    follow_redirect!
    expect(response.body).to include("no email was provided")
  end
end
