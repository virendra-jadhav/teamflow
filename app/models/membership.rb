class Membership < ApplicationRecord
  belongs_to :user 
  belongs_to :account 

  enum :role, {
    admin: 'admin',
    member: 'member'
  }
  validates :role, presence: true
end