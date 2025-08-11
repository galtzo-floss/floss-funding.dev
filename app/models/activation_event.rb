class ActivationEvent < ApplicationRecord
  belongs_to :activation_key, counter_cache: :activation_event_count
  belongs_to :account, optional: true

  include FlagShihTzu
  has_flags 1 => :donation_affirmed

  validates :activation_key, presence: true
  validates :donation_currency, presence: true

  before_destroy :prevent_destroy

  private

  def prevent_destroy
    errors.add(:base, 'Activation events cannot be deleted')
    throw(:abort)
  end
end
