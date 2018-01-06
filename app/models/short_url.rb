# == Schema Information
#
# Table name: short_urls
#
#  id            :integer          not null, primary key
#  original_url  :string
#  is_custom_url :boolean          default(FALSE)
#  short_uid     :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class ShortUrl < ApplicationRecord
  validates :original_url, presence: true, format: { with: /.*:\/\//, message: "should start with http:// or https://" }
  validates :short_uid, presence: true, uniqueness: true, if: proc { |short_url| short_url.is_custom_url? }
  validate :ensure_existing_url
  before_save :ensure_short_uid

  def ensure_short_uid
    self.short_uid = generate_short_uid if short_uid.blank? || !is_custom_url?
  end

  def generate_short_uid
    length = 4
    loop do
      uid = SecureRandom.urlsafe_base64(length).downcase
      break uid unless ShortUrl.exists?(short_uid: uid)
      length += 1
    end
  end

  def get_short_url
    Rails.application.routes.url_helpers.shorten_url(short_uid, host: ENV['SHORTENER_DOMAIN'])
  end

  def ensure_existing_url
  	return if is_custom_url?
  	url_exist = ShortUrl.where(original_url: original_url, is_custom_url: false)
  	errors.add(:original_url, "has been shorten before to: #{url_exist.last.get_short_url}") if url_exist.any?
  end
end
