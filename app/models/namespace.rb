class Namespace < ApplicationRecord
  has_many :activation_keys

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 1, maximum: 100 }

  after_create :link_matching_activation_keys

  private

  def link_matching_activation_keys
    ActivationKey.where(namespace: name).update_all(namespace_id: id)
  end
end
