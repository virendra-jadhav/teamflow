# app/models/audit_log.rb
class AuditLog < ApplicationRecord
  belongs_to :account
  belongs_to :actor, class_name: "User"

  validates :action, presence: true
  validates :target_type, presence: true
  validates :target_id, presence: true

   def self.record!(account:, actor:, target:, action:, metadata: {})
    create!(
      account: account,
      actor: actor,
      target_type: target.class.name,
      target_id: target.id,
      action: action,
      metadata: metadata
    )
  end
end
