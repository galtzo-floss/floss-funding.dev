# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Projects" do
  describe "GET /projects" do
    it "renders the index" do
      Project.create!(name: "Alpha", ecosystem: "ruby")
      Project.create!(name: "Beta", ecosystem: "ruby")

      get projects_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Projects").or include("Project")
    end
  end

  describe "GET /projects/:id" do
    it "renders the show" do
      project = Project.create!(name: "LibX", ecosystem: "ruby")
      get project_path(project)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("LibX").or include("Project")
    end
  end
end
