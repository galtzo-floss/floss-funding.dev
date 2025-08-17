# frozen_string_literal: true

# Configure Zeitwerk inflections so directories under lib/ map to the correct constants.
# In particular, ensure "omniauth" maps to "OmniAuth" and "oauth2" maps to "OAuth2".
Rails.autoloaders.main.inflector.inflect(
  "omniauth" => "OmniAuth",
  "oauth2" => "OAuth2",
)
