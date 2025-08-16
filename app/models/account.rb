class Account < ApplicationRecord
  has_many :activation_events, dependent: :nullify

  validates :email, presence: true, uniqueness: {case_sensitive: false}

  def display_name
    email
  end
end
