class Account < ApplicationRecord
     # Associations
     has_many :memberships, dependent: :destroy
     has_many :users, through: :memberships
     has_many :invitations, dependent: :destroy

     # validations
     validates :name, presence: true
end
