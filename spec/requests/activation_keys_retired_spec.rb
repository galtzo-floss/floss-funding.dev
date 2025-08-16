require 'rails_helper'

RSpec.describe 'ActivationKeys retired behavior', type: :request do
  let!(:account) { Account.create!(email: 'user@example.com') }
  let!(:identity) { Identity.create!(account: account, email: account.email, password: 'secret123', password_confirmation: 'secret123') }

  before do
    post session_path, params: { email: account.email, password: 'secret123' }
  end

  it 'excludes retired keys from index and namespace/library lists, but allows show by ID and excludes from featured' do
    lib = 'Lib'
    ns = 'org'
    active = ActivationKey.create!(library_name: lib, namespace: ns, key: 'active', ecosystem: 'ruby', project_name: 'Proj', featured: true)
    retired = ActivationKey.create!(library_name: lib, namespace: ns, key: 'retired', ecosystem: 'ruby', project_name: 'Proj', featured: true, retired: true)

    # Index should show only active
    get activation_keys_path
    expect(response).to have_http_status(:ok)
    expect(response.body).to include('org/active')
    expect(response.body).not_to include('org/retired')

    # Show page for retired should be accessible by ID
    get activation_key_path(retired)
    expect(response).to have_http_status(:ok)
    expect(response.body).to include('org/retired')

    # Namespace list on the retired show page should not include the retired key (but will include other active ones)
    expect(response.body).to include('org/active')

    # Library show should list only active
    get library_path(retired.library)
    expect(response.body).to include('org/active')
    expect(response.body).not_to include('org/retired')

    # Namespaces show should list only active
    get namespace_path(retired.namespace_record)
    expect(response.body).to include('org/active')
    expect(response.body).not_to include('org/retired')

    # Featured carousel should not include retired even if featured flag set
    get root_path
    expect(response).to have_http_status(:ok)
    expect(response.body).not_to include('org/retired')
  end
end
