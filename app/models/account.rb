class Account < ApplicationRecord
     # Associations
     has_many :memberships, dependent: :destroy
     has_many :users, through: :memberships

     # validations
     validates :name, presence: true
end
