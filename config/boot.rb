ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.

# NOTE: needs to load before active_support, so the magic will work.
# require "activesupport-tagged_logging"
# Activesupport::FixPr53105.init

require "bootsnap/setup" # Speed up boot time by caching expensive operations.
