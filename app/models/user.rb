class User < ApplicationRecord
  has_secure_password
  MAX_LOGIN_ATTEMPTS = 5
  LOCK_DURATION = 30.minutes

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

  # Confirmation mail
  before_create :set_confirmation_token
  scope :confirmed, -> { where.not(confirmed_at: nil) }
  def confirmed?
    confirmed_at.present?
  end
  def confirm!
    update!(
      confirmed_at: Time.current,
      confirmation_token: nil
    )
  end
  def confirmation_expired?
    confirmation_sent_at < 2.days.ago
  end

  # resend email confirmation
  def regenerate_confirmation!
    update!(
      confirmation_token: SecureRandom.urlsafe_base64(32),
      confirmation_sent_at: Time.current
    )
  end

  # -------------------------
  # Remember-me logic
  # -------------------------

  attr_accessor :remember_token

  def remember!
    self.remember_token = SecureRandom.urlsafe_base64
    update!(
      remember_digest: BCrypt::Password.create(remember_token)
    )
  end
  def forget!
    update!(remember_digest: nil)
  end

  def authenticate_with_remember_token?(token)
    return false if remember_digest.blank?
    BCrypt::Password.new(remember_digest).is_password?(token)
  end


  ### locking functionality
  def locked?
        locked_at.present? && locked_at > LOCK_DURATION.ago
  end
  def increment_failed_attempts!
    increment!(:failed_attempts)
    lock! if failed_attempts >= MAX_LOGIN_ATTEMPTS
  end
  def reset_failed_attempts!
    update!(failed_attempts: 0)
  end

  def lock!
    update!(
      locked_at: Time.current,
      failed_attempts: MAX_LOGIN_ATTEMPTS
    )
  end
  def unlock!
    update!(
      locked_at: nil,
      failed_attempts: 0,
      unlock_token_digest: nil
    )
  end
  # unlock login attemps
  def generate_unlock_token!
    token = SecureRandom.urlsafe_base64(32)
    digest = BCrypt::Password.create(token)
    update!(unlock_token_digest: digest)
    token
  end
  def valid_unlock_token?(token)
    return false if unlock_token_digest.blank?
    BCrypt::Password.new(unlock_token_digest).is_password?(token)
  end

  private

  def set_confirmation_token
    self.confirmation_token = SecureRandom.urlsafe_base64(32)
    self.confirmation_sent_at = Time.current
  end

  def handle_unique_email_violation
    yield
  rescue ActiveRecord::RecordNotUnique
    errors.add(:email, "has already been taken")
    throw(:abort)
  end
end
