class AccountsController < ApplicationController
  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    if @account.valid?
      ActiveRecord::Base.transaction do
        @account.save!
        Identity.create!(account: @account, email: @account.email, password: params[:account][:password], password_confirmation: params[:account][:password_confirmation])
      end
      session[:account_id] = @account.id
      redirect_to activation_keys_path, notice: 'Account created successfully'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def account_params
    params.require(:account).permit(:email)
  end
end
