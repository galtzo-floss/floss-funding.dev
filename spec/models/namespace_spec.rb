require 'rails_helper'

RSpec.describe Namespace, type: :model do
  it 'auto-exists and is linked when an activation key is created' do
    key = ActivationKey.create!(library_name: 'LibZ', namespace: 'orgz', key: 'libz', ecosystem: 'ruby', project_name: 'ProjZ')
    ns = described_class.find_by!(name: 'orgz')
    expect(key.reload.namespace_id).to eq(ns.id)
  end
end
