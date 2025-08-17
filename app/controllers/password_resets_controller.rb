class PasswordResetsController < ApplicationController
  # No authentication required: reset flow accessible to unauthenticated users
  skip_before_action :verify_authenticity_token, only: [:update]

  def new
  end

  def create
    email = params[:email].to_s.strip.downcase
    identity = Identity.find_by(email: email)

    if identity
      token = PasswordResetToken.issue_for(identity)
      PasswordResetMailer.with(identity: identity, token: token).reset_email.deliver_later
    end

    # For security, do not reveal whether the email exists
    redirect_to(root_path, notice: "If that email exists in our system, we've sent a password reset link.")
  end

  def edit
    @token = PasswordResetToken.find_by(token: params[:token])
    if @token.nil? || @token.used? || @token.expired?
      redirect_to(new_password_reset_path, alert: "Your password reset link is invalid or has expired. Please request a new one.")
    end
  end

  def update
    @token = PasswordResetToken.find_by(token: params[:token])
    if @token.nil? || @token.used? || @token.expired?
      redirect_to(new_password_reset_path, alert: "Your password reset link is invalid or has expired. Please request a new one.") and return
    end

    password = params[:password].to_s
    password_confirmation = params[:password_confirmation].to_s

    if password.blank? || password != password_confirmation
      flash.now[:alert] = "Passwords must match and cannot be blank"
      render(:edit, status: :unprocessable_entity) and return
    end

    identity = @token.identity
    if identity.update(password: password, password_confirmation: password_confirmation)
      @token.destroy! # one-time use: destroy token after success
      redirect_to(new_session_path, notice: "Your password has been reset. You can now log in.")
    else
      flash.now[:alert] = identity.errors.full_messages.to_sentence
      render(:edit, status: :unprocessable_entity)
    end
  end
end
