class PasswordResetMailer < ApplicationMailer
  default from: "no-reply@floss-funding.dev"

  def reset_email
    @identity = params[:identity]
    @token = params[:token]
    @reset_url = edit_password_reset_url(token: @token.token)
    mail(to: @identity.email, subject: "Reset your FLOSS Funding password")
  end
end
