class NamespacesController < ApplicationController
  def index
    @namespaces = Namespace.order(:name).includes(:activation_keys)
  end

  def show
    @namespace = Namespace.find(params[:id])
    @activation_keys = @namespace.activation_keys.where(retired: false).order(:key)
  end
end
