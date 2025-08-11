# frozen_string_literal: true

require "rails_helper"

RSpec.describe "RSpec setup" do
  it "loads the Rails environment and runs a basic expectation" do
    expect(Rails.application.class.module_parent_name).to eq("FlossFundingDev")
  end
end
