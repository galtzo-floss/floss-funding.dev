class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("DEFAULT_FROM", "no-reply@galtzo.com")
  layout "mailer"
end
