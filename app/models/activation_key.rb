class ActivationKey < ApplicationRecord
  has_many :activation_events, dependent: :restrict_with_error

  include FlagShihTzu
  has_flags 1 => :featured

  validates :namespace, presence: true
  validates :key, presence: true, uniqueness: { scope: :namespace, case_sensitive: false }
  validates :ecosystem, presence: true

  has_enumeration_for :ecosystem, with: Ecosystem, create_helpers: true, required: true

  before_destroy :prevent_destroy

  private

  def prevent_destroy
    errors.add(:base, 'Activation keys cannot be deleted')
    throw(:abort)
  end
end
