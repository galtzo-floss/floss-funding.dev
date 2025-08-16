class LibrariesController < ApplicationController
  def index
    @libraries = Library.order(:name).includes(:activation_keys)
  end

  def show
    @library = Library.find(params[:id])
    @activation_keys = @library.activation_keys.order(:namespace, :key)
  end
end
