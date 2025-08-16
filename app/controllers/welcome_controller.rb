class WelcomeController < ApplicationController
  def index
    # Randomize to keep the carousel fresh on each load
    # Select libraries that have at least one active, featured activation key
    @featured_libraries = Library
      .joins(:activation_keys)
      .merge(ActivationKey.active.featured)
      .distinct
      .order(Arel.sql("RANDOM()"))
      .limit(20)
  end

  def about
  end
end
