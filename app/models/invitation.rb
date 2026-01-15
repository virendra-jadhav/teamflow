class Invitation < ApplicationRecord
  # -----------------------
  # Associations
  # -----------------------
  belongs_to :account
  belongs_to :invited_by, class_name: "User"

  # -----------------------
  # Validations
  # -----------------------
  VALID_ROLES = %w[admin member].freeze

  validates :email, presence: true
  validates :role, presence: true, inclusion: { in: VALID_ROLES }
  validates :token, presenct: true, uniqueness: true
  validates :expires_at, presence: true

  # -----------------------
  # Scopes
  # -----------------------
  scope :pending, -> { where(accepted_at: nil) }
  scope :expired, -> { where("expires_at < ?", Time.current) }


  # -----------------------
  # State helpers
  # -----------------------
  def accepted?
    accepted_at.present?
  end
  def expired?
    expires_at < Time.current
  end
  def usable?
    !accepted? && !expired?
  end
end
