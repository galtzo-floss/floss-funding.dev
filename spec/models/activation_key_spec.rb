require "rails_helper"

RSpec.describe ActivationKey, type: :model do
  it "validates required fields and enum" do
    key = described_class.new
    expect(key).not_to be_valid
    key.library_name = "Library"
    key.namespace = "org"
    key.key = "lib"
    key.ecosystem = "ruby"
    key.project_name = "My Awesome Project"
    expect(key).to be_valid
  end

  it "uses flag_shih_tzu for featured" do
    key = described_class.create!(library_name: "Lib", namespace: "org", key: "lib", ecosystem: "ruby", project_name: "Proj")
    expect(key).not_to be_featured
    key.featured = true
    key.save!
    expect(key.reload).to be_featured
  end

  it "prevents destroy" do
    key = described_class.create!(library_name: "Lib", namespace: "org", key: "lib", ecosystem: "ruby", project_name: "Proj")
    expect(key.destroy).to be_falsey
    expect(key.errors[:base]).to include("Activation keys cannot be deleted")
    expect(described_class.exists?(key.id)).to be_truthy
  end

  it "counter caches activation events" do
    key = described_class.create!(library_name: "Lib", namespace: "o", key: "l", ecosystem: "ruby", project_name: "Proj")
    expect { ActivationEvent.create!(activation_key: key, donation_currency: "USD") }.to change { key.reload.activation_event_count }.from(0).to(1)
  end

  it "auto-creates and links namespace, library, and project on create" do
    key = described_class.create!(library_name: "LibAA", namespace: "org.aa", key: "libaa", ecosystem: "ruby", project_name: "ProjAA")
    expect(key.library).to be_present
    expect(key.namespace_record).to be_present
    expect(key.project).to be_present
    expect(key.library.name).to eq("LibAA")
    expect(key.namespace_record.name).to eq("org.aa")
    expect(key.project.name).to eq("ProjAA")
  end
end
