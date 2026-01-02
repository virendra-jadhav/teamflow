class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email,
           presence: true,
           uniqueness: true,
           format: { with: URI::MailTo::EMAIL_REGEXP }

  enum :role, { member: "member", admin: "admin" }
  validates :role, presence: true
  validates :password, presence: true, on: :create

  around_save :handle_unique_email_violation

  # Password reset functionality
  RESET_TOKEN_EXPIRY = 2.hours

  def generate_password_reset!
    token = SecureRandom.urlsafe_base64(32)

    update!(
      reset_password_token: token,
      reset_password_sent_at: Time.current
    )
    token
  end
  def reset_token_expired?
    reset_password_sent_at < RESET_TOKEN_EXPIRY.ago
  end

  def clear_password_reset!
    update!(
      reset_password_token: nil,
      reset_password_sent_at: nil,
    )
  end

  private

  def handle_unique_email_violation
    yield
  rescue ActiveRecord::RecordNotUnique
    errors.add(:email, "has already been taken")
    throw(:abort)
  end
end
