# frozen_string_literal: true

require "rails_helper"

RSpec.describe "OmniAuth Codeberg strategy" do
  it "is defined under the correct constant" do
    expect(defined?(OmniAuth::Strategies::Codeberg)).to be_truthy
  end

  describe "::Codeberg" do
    subject(:strategy) { OmniAuth::Strategies::Codeberg }

    it "inherits from OAuth2 strategy" do
      expect(strategy < OmniAuth::Strategies::OAuth2).to be(true)
    end

    describe "defaults" do
      let(:app) { ->(_env) { [200, {"Content-Type" => "text/plain"}, ["ok"]] } }
      subject(:instance) { strategy.new(app) }

      it "has the provider name set" do
        expect(instance.options.name).to eq("codeberg")
      end

      it "has default client_options pointing at Codeberg" do
        expect(instance.options.client_options.site).to eq("https://codeberg.org")
        expect(instance.options.client_options.authorize_url).to eq("/login/oauth/authorize")
        expect(instance.options.client_options.token_url).to eq("/login/oauth/access_token")
      end
    end
  end
end
