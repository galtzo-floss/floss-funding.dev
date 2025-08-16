require 'rails_helper'

RSpec.describe Library, type: :model do
  it 'auto-exists and is linked when an activation key is created' do
    key = ActivationKey.create!(library_name: 'LibY', namespace: 'orgy', key: 'liby', ecosystem: 'ruby', project_name: 'ProjY')
    library = described_class.find_by!(name: 'LibY')
    expect(key.reload.library_id).to eq(library.id)
  end
end
