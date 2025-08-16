class WelcomeController < ApplicationController
  def index
    # Randomize to keep the carousel fresh on each load
    @featured_activation_keys = ActivationKey.where("flags & ? > 0", 1).where(retired: false).order(Arel.sql("RANDOM()")).limit(20)
  end

  def about
  end
end
