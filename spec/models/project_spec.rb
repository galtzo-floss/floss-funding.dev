require "rails_helper"

RSpec.describe Project, type: :model do
  it "auto-exists and is linked when an activation key is created (if project_name present)" do
    key = ActivationKey.create!(library_name: "LibX", namespace: "orgx", key: "libx", ecosystem: "ruby", project_name: "ProjX")
    project = described_class.find_by!(name: "ProjX")
    expect(key.reload.project_id).to eq(project.id)
  end
end
