require 'rails_helper'

RSpec.describe ActivationEvent, type: :model do
  let(:key) { ActivationKey.create!(library_name: 'Lib', namespace: 'org', key: 'lib', ecosystem: 'ruby', project_name: 'Proj') }

  it 'validates presence of activation_key and has USD as default currency' do
    event = described_class.new
    expect(event).not_to be_valid
    event.activation_key = key
    # default should be USD from DB default
    expect(event.donation_currency).to eq('USD')
    expect(event).to be_valid
  end

  it 'supports donation_affirmed flag' do
    event = described_class.create!(activation_key: key, donation_currency: 'USD')
    expect(event).not_to be_donation_affirmed
    event.donation_affirmed = true
    event.save!
    expect(event.reload).to be_donation_affirmed
  end

  it 'prevents destroy' do
    event = described_class.create!(activation_key: key, donation_currency: 'USD')
    expect(event.destroy).to be_falsey
    expect(event.errors[:base]).to include('Activation events cannot be deleted')
    expect(described_class.exists?(event.id)).to be_truthy
  end
end
