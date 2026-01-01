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

  private

  def handle_unique_email_violation
    yield
  rescue ActiveRecord::RecordNotUnique
    errors.add(:email, "has already been taken")
    throw(:abort)
  end
end
