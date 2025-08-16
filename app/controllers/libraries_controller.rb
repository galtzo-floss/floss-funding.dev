class LibrariesController < ApplicationController
  def index
    @libraries = Library.order(:name)
  end
end
