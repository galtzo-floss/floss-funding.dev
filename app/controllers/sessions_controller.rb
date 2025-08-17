class SessionsController < ApplicationController
  protect_from_forgery except: [:omniauth]

  def new
  end

  # Password sign-in (Identity)
  def create
    identity = Identity.find_by(email: params[:email])
    if identity&.authenticate(params[:password])
      session[:account_id] = identity.account_id
      redirect_to(activation_keys_path, notice: "Signed in successfully")
    else
      flash.now[:alert] = "Invalid email or password"
      render(:new, status: :unprocessable_entity)
    end
  end

  # OmniAuth callback for external providers
  def omniauth
    auth = request.env["omniauth.auth"]
    if auth.blank?
      redirect_to(new_session_path, alert: "Authentication failed: missing data") and return
    end

    email = auth.dig("info", "email")
    name = auth.dig("info", "name") || auth.dig("info", "nickname")

    if email.blank?
      redirect_to(new_session_path, alert: "Authentication succeeded but no email was provided. Please ensure email scope is granted and public/primary email is set.") and return
    end

    account = Account.find_or_create_by!(email: email) do |acc|
      # In the future we could store name/avatar. For now Account only has email.
    end

    session[:account_id] = account.id
    redirect_to(activation_keys_path, notice: "Signed in as #{name || email}")
  rescue StandardError => e
    Rails.logger.error("OmniAuth error: #{e.class}: #{e.message}")
    redirect_to(new_session_path, alert: "Authentication failed")
  end

  def failure
    message = params[:message].presence || "Unknown error"
    redirect_to(new_session_path, alert: "Authentication failed: #{message}")
  end

  def destroy
    reset_session
    redirect_to(root_path, notice: "Signed out")
  end
end
