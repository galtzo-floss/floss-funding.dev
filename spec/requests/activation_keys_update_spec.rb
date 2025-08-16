require 'rails_helper'

RSpec.describe 'ActivationKeys updates', type: :request do
  let!(:account) { Account.create!(email: 'user@example.com') }
  let!(:identity) { Identity.create!(account: account, email: account.email, password: 'secret123', password_confirmation: 'secret123') }

  before do
    post session_path, params: { email: account.email, password: 'secret123' }
  end

  it 'allows updating only permitted fields' do
    key = ActivationKey.create!(library_name: 'Lib', namespace: 'org', key: 'lib', ecosystem: 'ruby', project_name: 'Proj', project_url: 'https://example.com')

    patch activation_key_path(key), params: {
      activation_key: {
        library_name: 'Lib2',
        project_name: 'Proj2',
        project_url: 'https://proj.example.com',
        featured: '1',
        free_for_open_source: '1',
        # Attempt forbidden changes
        namespace: 'hacked',
        key: 'hacked',
        ecosystem: 'python'
      }
    }
    expect(response).to redirect_to(activation_key_path(key))

    key.reload
    expect(key.library_name).to eq('Lib2')
    expect(key.project_name).to eq('Proj2')
    expect(key.project_url).to eq('https://proj.example.com')
    expect(key).to be_featured
    expect(key).to be_free_for_open_source

    # Ensure forbidden attributes were not changed
    expect(key.namespace).to eq('org')
    expect(key.key).to eq('lib')
    expect(key.ecosystem).to eq('ruby')
  end

  it 'does not allow clearing required fields when OSS enabled' do
    key = ActivationKey.create!(library_name: 'Lib', namespace: 'org', key: 'lib', ecosystem: 'ruby', project_name: 'Proj', project_url: 'https://example.com', free_for_open_source: true)

    patch activation_key_path(key), params: {
      activation_key: {
        project_name: '',
        project_url: ''
      }
    }

    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.body).to include('Project name')
  end
end
