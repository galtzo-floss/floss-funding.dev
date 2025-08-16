require "rails_helper"

RSpec.describe "ActivationKey show namespace list", type: :request do
  let!(:account) { Account.create!(email: "user@example.com") }
  let!(:identity) { Identity.create!(account: account, email: account.email, password: "secret123", password_confirmation: "secret123") }

  before do
    post session_path, params: {email: account.email, password: "secret123"}
  end

  it "shows an index list of all activation keys for the same namespace on the show page" do
    a = ActivationKey.create!(library_name: "Lib A", namespace: "org", key: "alpha", ecosystem: "ruby", project_name: "Proj A")
    ActivationKey.create!(library_name: "Lib B", namespace: "org", key: "beta", ecosystem: "ruby", project_name: "Proj B")
    _other_ns = ActivationKey.create!(library_name: "Lib X", namespace: "other", key: "x", ecosystem: "ruby", project_name: "Proj X")

    get activation_key_path(a)
    expect(response).to have_http_status(:ok)

    # Both org/alpha and org/beta should appear in the namespace list
    expect(response.body).to include("org/alpha")
    expect(response.body).to include("org/beta")

    # The different-namespace key should not be listed by name+key combination
    expect(response.body).not_to include("other/x")
  end
end
