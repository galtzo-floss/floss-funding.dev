# frozen_string_literal: true

# Galtzo FLOSS Rakefile v1.0.2 (rails version) - 2025-08-12
#
# MIT License (see License.txt)
#
# Copyright (c) 2025 Peter H. Boling (galtzo.com)
#
# Expected to work in any project that uses Bundler.
#
# Sets up tasks for rspec, minitest, rubocop, reek, yard.

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

defaults = []

is_ci = ENV.fetch("CI", "false").casecmp("true") == 0

### DEVELOPMENT TASKS
# Setup Kettle Soup Cover
begin
  require "kettle-soup-cover"

  Kettle::Soup::Cover.install_tasks
  # NOTE: Coverage on CI is configured independent of this task.
  #       This task is for local development, as it opens results in browser
  defaults << "coverage" unless Kettle::Soup::Cover::IS_CI
rescue LoadError
  desc("(stub) coverage is unavailable")
  task("coverage") do
    warn("NOTE: kettle-soup-cover isn't installed, or is disabled for #{RUBY_VERSION} in the current environment")
  end
end

# Setup Bundle Audit
begin
  require "bundler/audit/task"

  Bundler::Audit::Task.new
  defaults.push("bundle:audit:update", "bundle:audit")
rescue LoadError
  desc("(stub) bundle:audit is unavailable")
  task("bundle:audit") do
    warn("NOTE: bundler-audit isn't installed, or is disabled for #{RUBY_VERSION} in the current environment")
  end
  desc("(stub) bundle:audit:update is unavailable")
  task("bundle:audit:update") do
    warn("NOTE: bundler-audit isn't installed, or is disabled for #{RUBY_VERSION} in the current environment")
  end
end

# Setup RSpec
begin
  require "rspec/core/rake_task"

  RSpec::Core::RakeTask.new(:spec)
  # This takes the place of `coverage` task when running as CI=true
  defaults << "spec" if !defined?(Kettle::Soup::Cover) || Kettle::Soup::Cover::IS_CI
rescue LoadError
  desc("spec task stub")
  task(:spec) do
    warn("NOTE: rspec isn't installed, or is disabled for #{RUBY_VERSION} in the current environment")
  end
end

# Setup MiniTest
begin
  require "rake/testtask"

  Rake::TestTask.new(:test) do |t|
    t.test_files = FileList["tests/**/test_*.rb"]
  end
rescue LoadError
  desc("test task stub")
  task(:test) do
    warn("NOTE: minitest isn't installed, or is disabled for #{RUBY_VERSION} in the current environment")
  end
end

# rubocop:disable Rake/DuplicateTask
if Rake::Task.task_defined?("spec") && !Rake::Task.task_defined?("test")
  desc "run spec task with test task"
  task test: :spec
elsif !Rake::Task.task_defined?("spec") && Rake::Task.task_defined?("test")
  desc "run test task with spec task"
  task spec: :test
else
  # Add spec as pre-requisite to 'test'
  Rake::Task[:test].enhance(["spec"])
end
# rubocop:enable Rake/DuplicateTask

# Setup RuboCop-LTS
begin
  require "rubocop/lts"

  Rubocop::Lts.install_tasks
  # Make autocorrect the default rubocop task
  defaults << "rubocop_gradual:autocorrect"
rescue LoadError
  desc("(stub) rubocop_gradual is unavailable")
  task(:rubocop_gradual) do
    warn("NOTE: rubocop-lts isn't installed, or is disabled for #{RUBY_VERSION} in the current environment")
  end
end

# Setup Reek
begin
  require "reek/rake/task"

  Reek::Rake::Task.new do |t|
    t.fail_on_error = true
    t.verbose = false
    t.source_files = "{lib,spec,tests}/**/*.rb"
  end

  # Store current Reek output into REEK file
  require "open3"
  desc("Run reek and store the output into the REEK file")
  task("reek:update") do
    # Run via Bundler if available to ensure the right gem version is used
    cmd = [Gem.bindir ? File.join(Gem.bindir, "bundle") : "bundle", "exec", "reek"]

    output, status = Open3.capture2e(*cmd)

    File.write("REEK", output)

    # Mirror the failure semantics of the standard reek task
    unless status.success?
      abort("reek:update failed (reek reported smells). Output written to REEK")
    end
  end
  defaults << "reek:update" unless is_ci
rescue LoadError
  desc("(stub) reek is unavailable")
  task(:reek) do
    warn("NOTE: reek isn't installed, or is disabled for #{RUBY_VERSION} in the current environment")
  end
end

# Setup Yard
begin
  require "yard"

  YARD::Rake::YardocTask.new(:yard) do |t|
    t.files = [
      # Source Splats (alphabetical)
      "lib/**/*.rb",
      "-", # source and extra docs are separated by "-"
      # Extra Files (alphabetical)
      "*.cff",
      "*.md",
      "*.txt",
      "REEK",
    ]
  end
  defaults << "yard"
rescue LoadError
  desc("(stub) yard is unavailable")
  task(:yard) do
    warn("NOTE: yard isn't installed, or is disabled for #{RUBY_VERSION} in the current environment")
  end
end

task default: defaults
