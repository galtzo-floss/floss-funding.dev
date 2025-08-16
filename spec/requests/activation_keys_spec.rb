require 'rails_helper'

RSpec.describe 'ActivationKeys', type: :request do
  let!(:account) { Account.create!(email: 'user@example.com') }
  let!(:identity) { Identity.create!(account: account, email: account.email, password: 'secret123', password_confirmation: 'secret123') }

  before do
    # Log in via sessions controller
    post session_path, params: { email: account.email, password: 'secret123' }
  end

  it 'lists activation keys and allows creating new key' do
    get activation_keys_path
    expect(response).to have_http_status(:ok)

    post activation_keys_path, params: { activation_key: { namespace: 'org', key: 'lib', ecosystem: 'ruby', project_name: 'Proj', featured: '1' } }
    expect(response).to redirect_to(activation_keys_path)

    follow_redirect!
    expect(response.body).to include('org/lib')
    expect(ActivationKey.last).to be_featured
  end
end
