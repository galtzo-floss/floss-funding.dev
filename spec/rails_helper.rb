# frozen_string_literal: true

# External gems
require "kettle-soup-cover"

# This file is copied to spec/ when you run 'rails generate rspec:install'
# We provide a preconfigured version compatible with Rails 8
require "spec_helper"
ENV["RAILS_ENV"] ||= "test"

# Last thing before loading the app-under-test is code coverage.
require "simplecov" if Kettle::Soup::Cover::DO_COV # `.simplecov` is run here!
require File.expand_path("../config/environment", __dir__)

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require "rspec/rails"

# Require additional support files in spec/support/ if present
support_glob = File.join(__dir__, "support", "**", "*.rb")
Dir[support_glob].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # If using fixtures, uncomment and keep your fixtures under spec/fixtures
  # config.fixture_path = ::Rails.root.join('spec/fixtures')

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under spec/requests.
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace('gem name')

  # System tests / Capybara setup
  require "capybara/rspec"
  require "capybara/rails"
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, :js, type: :system) do
    # Requires selenium-webdriver to be present in the Gemfile's test group
    driven_by :selenium, using: :headless_chrome
  end
end
