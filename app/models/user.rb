class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, if: :validate_password?

  def generate_password_reset_token!
    self.reset_password_token = SecureRandom.urlsafe_base64
    self.reset_password_sent_at = Time.current
    save!
  end

  def password_reset_token_expired?
    reset_password_sent_at < 2.hours.ago
  end

  private

  def validate_password?
    new_record? || password.present? || password_confirmation.present?
  end
end
