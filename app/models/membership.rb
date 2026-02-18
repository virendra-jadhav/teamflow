class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :account
  has_one_attached :avatar

  AVATAR_THUMB = { resize_to_fill: [ 48, 48 ] }.freeze

  enum :role, {
    admin: "admin",
    member: "member"
  }
  validates :role, presence: true

  def avatar_thumb
    avatar.variant(AVATAR_THUMB)
  end
end
