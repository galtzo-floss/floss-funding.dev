class RetiredActivationKeysController < ApplicationController
  before_action :authenticate_account!

  def index
    @activation_keys = ActivationKey.where(retired: true).order(created_at: :desc)
  end
end
