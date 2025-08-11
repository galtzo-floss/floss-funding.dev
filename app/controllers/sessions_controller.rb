class SessionsController < ApplicationController
  def new
  end

  # OmniAuth callback
  def create
    # Using Identity model to authenticate email/password
    identity = Identity.find_by(email: params[:email])
    if identity&.authenticate(params[:password])
      session[:account_id] = identity.account_id
      redirect_to activation_keys_path, notice: 'Signed in successfully'
    else
      flash.now[:alert] = 'Invalid email or password'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'Signed out'
  end
end
