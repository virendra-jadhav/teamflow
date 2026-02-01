class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :account
  has_one_attached :avatar

  enum :role, {
    admin: "admin",
    member: "member"
  }
  validates :role, presence: true
end
