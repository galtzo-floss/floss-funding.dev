class ActivationKeysController < ApplicationController
  before_action :authenticate_account!

  def index
    @activation_keys = ActivationKey.order(created_at: :desc)
  end

  def show
    @activation_key = ActivationKey.find(params[:id])
    @namespace_activation_keys = ActivationKey.where(namespace: @activation_key.namespace).order(:key)
  end

  def new
    @activation_key = ActivationKey.new
  end

  def create
    @activation_key = ActivationKey.new(activation_key_params)
    if @activation_key.save
      redirect_to activation_keys_path, notice: 'Activation key created'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def activation_key_params
    params.require(:activation_key).permit(:library_name, :namespace, :key, :ecosystem, :featured, :free_for_open_source, :project_name, :project_url)
  end
end
