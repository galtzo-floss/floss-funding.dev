class ActivationKey < ApplicationRecord
  has_many :activation_events, dependent: :restrict_with_error

  include FlagShihTzu
  has_flags 1 => :featured,
            2 => :free_for_open_source

  validates :namespace, presence: true
  validates :key, presence: true, uniqueness: { scope: :namespace, case_sensitive: false }
  validates :ecosystem, presence: true
  validates :library_name, presence: true

  validates :project_name, presence: true, if: :free_for_open_source?
  validates :project_name, length: { minimum: 2, maximum: 100 }, format: { with: /\A[[:alnum:]][[:alnum:] ._\-+\/]{1,99}\z/, message: 'must be 2-100 characters with letters, numbers, spaces, and ._-+/' }, allow_blank: true
  validates :project_url, presence: true, if: :free_for_open_source?

  has_enumeration_for :ecosystem, with: Ecosystem, create_helpers: true, required: true

  before_destroy :prevent_destroy

  def badge_markdown
    # Show badge only when both fields are present and OSS is enabled
    return nil unless free_for_open_source? && project_name.present? && project_url.present?

    label = "#{project_name} ❤️ #{library_name}"
    encoded_label = ERB::Util.url_encode(label)

    logo = badge_logo_for(ecosystem)
    # Build shields URL with logo when available
    image_url = "https://img.shields.io/badge/#{encoded_label}-brightgreen" + (logo ? "?logo=#{ERB::Util.url_encode(logo)}&logoColor=white" : '')
    alt_text = label

    "[![#{alt_text}](#{image_url})](#{project_url})"
  end

  private

  def badge_logo_for(ecosystem)
    case ecosystem.to_s
    when 'ruby' then 'rubygems'
    when 'python' then 'pypi'
    when 'javascript' then 'npm'
    when 'php' then 'packagist'
    when 'perl' then 'cpan'
    when 'bash' then 'gnubash'
    when 'go' then 'go'
    when 'java' then 'java'
    when 'lua' then 'lua'
    else nil
    end
  end

  def prevent_destroy
    errors.add(:base, 'Activation keys cannot be deleted')
    throw(:abort)
  end
end
