# Configure sanitize_email to prevent sending real emails from the QA (Fly) environment.
# This is activated when ENABLE_SANITIZE_EMAIL=true is present in the environment.

if ENV["ENABLE_SANITIZE_EMAIL"]&.downcase == "true"
  require "sanitize_email"

  SanitizeEmail::Config.configure do |config|
    # Where should sanitized emails be redirected? Override via SANITIZE_TO.
    config.sanitized_to = ENV.fetch("SANITIZE_TO", "qa-mails@galtzo.com")
    config.sanitized_cc = nil
    config.sanitized_bcc = nil

    # Keep the original recipient visible in the subject for debugging.
    config.use_actual_email_prepended_to_subject = true

    # Always sanitize in this environment.
    config.force_sanitize = true

    # Ensure activation in production as well (we drive activation with the env var).
    config.local_environments = []

    # If any addresses should be allowed through without sanitizing, whitelist them here.
    # Allow galtzo.com addresses to go through as-is.
    config.whitelist = [/\A.+@galtzo\.com\z/i, /\A.+@floss-funding\.dev\z/i]

    # Alternatively, you could use an activation proc, but force_sanitize already ensures it.
    config.activation_proc = Proc.new { true }
  end
end
