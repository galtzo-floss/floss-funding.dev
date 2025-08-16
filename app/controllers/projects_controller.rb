class ProjectsController < ApplicationController
  def index
    @projects = Project.order(:name).includes(:activation_keys)
  end

  def show
    @project = Project.find(params[:id])
    @activation_keys = @project.activation_keys.order(:namespace, :key)
  end
end
