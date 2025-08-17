# frozen_string_literal: true

require "rails_helper"

RSpec.describe PasswordResetToken do
  describe "::issue_for" do
    it "creates a token for an identity with default TTL" do
      account = Account.create!(email: "user@example.com")
      identity = Identity.create!(account: account, email: "user@example.com", password: "secret", password_confirmation: "secret")

      token = described_class.issue_for(identity)

      expect(token).to be_persisted
      expect(token.identity).to eq(identity)
      expect(token.token).to be_a(String)
      expect(token.token.length).to be >= 43 # urlsafe_base64(32) ~ 43 chars
      expect(token.expires_at).to be_within(1.second).of(15.minutes.from_now)
    end
  end

  describe "scopes and predicates" do
    it "returns usable only for not used and not expired" do
      account = Account.create!(email: "user2@example.com")
      identity = Identity.create!(account: account, email: "user2@example.com", password: "secret", password_confirmation: "secret")

      usable = PasswordResetToken.create!(identity: identity, token: "tok1", expires_at: 10.minutes.from_now)
      used = PasswordResetToken.create!(identity: identity, token: "tok2", expires_at: 10.minutes.from_now, used_at: Time.current)
      expired = PasswordResetToken.create!(identity: identity, token: "tok3", expires_at: 10.minutes.ago)

      expect(described_class.usable).to contain_exactly(usable)
      expect(usable.used?).to be false
      expect(used.used?).to be true
      expect(expired.expired?).to be true
    end

    it "marks token used" do
      account = Account.create!(email: "user3@example.com")
      identity = Identity.create!(account: account, email: "user3@example.com", password: "secret", password_confirmation: "secret")
      token = PasswordResetToken.create!(identity: identity, token: "tok4", expires_at: 10.minutes.from_now)

      expect { token.mark_used! }.to change { token.reload.used_at }.from(nil)
      expect(token.used?).to be true
    end
  end
end
