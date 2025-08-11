require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FlossFundingDev
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults(8.0)

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Use RSpec as the test framework for generators
    config.generators do |g|
      g.test_framework(:rspec)
      # Disable fixtures by default (uncomment if using factory_bot later)
      # g.fixture_replacement :factory_bot, dir: "spec/factories"
      # Don’t generate view, helper, assets specs by default
      g.view_specs(false)
      g.helper_specs(false)
      g.assets(false)
      g.helper(false)
    end

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
