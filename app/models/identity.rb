class Identity < OmniAuth::Identity::Models::ActiveRecord
  self.table_name = 'identities'

  auth_key :email

  belongs_to :account

  validates :email, presence: true, uniqueness: { case_sensitive: false }
end
