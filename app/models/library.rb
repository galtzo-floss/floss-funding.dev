class Library < ApplicationRecord
  has_many :activation_keys

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 1, maximum: 100 }

  after_create :link_matching_activation_keys

  private

  def link_matching_activation_keys
    ActivationKey.where(library_name: name).update_all(library_id: id)
  end
end
