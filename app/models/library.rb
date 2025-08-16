class Library < ApplicationRecord
  has_many :activation_keys

  validates :name, presence: true, length: {minimum: 1, maximum: 100}
  validates :ecosystem, presence: true
  validates :name, uniqueness: {scope: :ecosystem, case_sensitive: false}

  after_create :link_matching_activation_keys

  private

  def link_matching_activation_keys
    ActivationKey.where(library_name: name, ecosystem: ecosystem).update_all(library_id: id)
  end
end
