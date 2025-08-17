# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Password resets" do
  describe "POST /password_resets" do
    it "always redirects and issues token when email exists" do
      account = Account.create!(email: "pass@example.com")
      Identity.create!(account: account, email: "pass@example.com", password: "secret", password_confirmation: "secret")

      expect {
        post password_resets_path, params: {email: "pass@example.com"}
      }.to change { PasswordResetToken.count }.by(1)

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("If that email exists")
    end

    it "does not leak whether the email exists" do
      expect {
        post password_resets_path, params: {email: "nope@example.com"}
      }.not_to change { PasswordResetToken.count }

      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET /password_resets/:token/edit" do
    it "redirects for invalid/expired/used token" do
      get edit_password_reset_path(token: "missing")
      expect(response).to redirect_to(new_password_reset_path)

      account = Account.create!(email: "e1@example.com")
      identity = Identity.create!(account: account, email: "e1@example.com", password: "secret", password_confirmation: "secret")
      expired = PasswordResetToken.create!(identity: identity, token: "tok-expired", expires_at: 1.minute.ago)

      get edit_password_reset_path(token: expired.token)
      expect(response).to redirect_to(new_password_reset_path)

      used = PasswordResetToken.create!(identity: identity, token: "tok-used", expires_at: 1.minute.from_now, used_at: Time.current)
      get edit_password_reset_path(token: used.token)
      expect(response).to redirect_to(new_password_reset_path)
    end
  end

  describe "PATCH /password_resets/:token" do
    it "updates password and destroys token on success" do
      account = Account.create!(email: "ok@example.com")
      identity = Identity.create!(account: account, email: "ok@example.com", password: "oldpass", password_confirmation: "oldpass")
      token = PasswordResetToken.issue_for(identity)

      patch password_reset_path(token: token.token), params: {password: "newpass", password_confirmation: "newpass"}

      expect(response).to redirect_to(new_session_path)
      expect { token.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "renders edit with errors when passwords do not match" do
      account = Account.create!(email: "bad@example.com")
      identity = Identity.create!(account: account, email: "bad@example.com", password: "oldpass", password_confirmation: "oldpass")
      token = PasswordResetToken.issue_for(identity)

      patch password_reset_path(token: token.token), params: {password: "x", password_confirmation: "y"}

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Passwords must match")
      expect(token.reload).to be_present
    end

    it "redirects for invalid token" do
      patch password_reset_path(token: "missing"), params: {password: "x", password_confirmation: "x"}
      expect(response).to redirect_to(new_password_reset_path)
    end
  end
end
