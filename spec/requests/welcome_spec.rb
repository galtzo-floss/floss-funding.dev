require 'rails_helper'

RSpec.describe 'Welcome page', type: :request do
  it 'renders the welcome page' do
    get root_path
    expect(response).to have_http_status(:ok)
    expect(response.body).to include('Welcome to FLOSS Funding')
  end
end
