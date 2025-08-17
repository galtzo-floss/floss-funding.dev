# frozen_string_literal: true

DEBUGGING = ENV.fetch("DEBUG", "false").casecmp("true").zero?

# External gems
require "debug" if DEBUGGING
require "silent_stream"
require "rspec/block_is_expected"
require "rspec/block_is_expected/matchers/not"
require "rspec/stubbed_env"

# Config files
require "config/timecop"

RSpec.configure do |config|
  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # This option will default to `:apply_to_host_groups` in RSpec 4 (and will
  # have no way to turn it off -- the option exists only for backwards
  # compatibility in RSpec 3). It causes shared context metadata to be
  # inherited by the metadata hash of host groups and examples, rather than
  # triggering implicit auto-inclusion in groups with matching metadata.
  config.shared_context_metadata_behavior = :apply_to_host_groups

  # Run focused specs, and when none tagged, run all
  config.filter_run_when_matching :focus

  # Allow running a subset by line number
  config.example_status_persistence_file_path = "spec/examples.txt"

  # Randomize test order to surface order dependencies.
  config.order = :random
  Kernel.srand config.seed

  # Infer spec type from file location (model, request, system, etc.)
  config.define_derived_metadata(file_path: %r{/spec/system/}) { |meta| meta[:type] = :system }
  config.define_derived_metadata(file_path: %r{/spec/requests?/}) { |meta| meta[:type] = :request }
  config.define_derived_metadata(file_path: %r{/spec/controllers?/}) { |meta| meta[:type] = :controller }
  config.define_derived_metadata(file_path: %r{/spec/models?/}) { |meta| meta[:type] = :model }

  # Filter Rails gems and noisy backtrace lines
  config.filter_gems_from_backtrace "rails", "activesupport", "activerecord", "actionpack"

  config.include(SilentStream)

  config.around(:each) do |example|
    # Silence STDOUT for examples NOT tagged with :check_output
    if DEBUGGING || example.metadata[:check_output]
      example.run
    else
      silence_stream($stdout) do
        example.run
      end
    end
  end
end
