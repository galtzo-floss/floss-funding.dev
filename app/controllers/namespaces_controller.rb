class NamespacesController < ApplicationController
  def index
    @namespaces = Namespace.order(:name)
  end
end
