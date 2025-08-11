require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  it 'allows creating an account and logging in' do
    # Sign up
    post accounts_path, params: { account: { email: 'user@example.com', password: 'secret123', password_confirmation: 'secret123' } }
    expect(response).to redirect_to(activation_keys_path)
    follow_redirect!
    expect(response.body).to include('Activation Keys')

    # Log out
    delete session_path
    expect(response).to redirect_to(root_path)

    # Log in
    post session_path, params: { email: 'user@example.com', password: 'secret123' }
    expect(response).to redirect_to(activation_keys_path)
  end
end
