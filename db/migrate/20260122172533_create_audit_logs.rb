class CreateAuditLogs < ActiveRecord::Migration[7.2]
  def change
     create_table :audit_logs do |t|
      t.references :account,
                   null: false,
                   type: :uuid,
                   foreign_key: true

      t.references :actor,
                   null: false,
                   type: :uuid,
                   foreign_key: { to_table: :users }

      t.string :target_type, null: false
      t.uuid   :target_id,   null: false

      t.string :action, null: false
      t.jsonb  :metadata, default: {}, null: false

      t.timestamps
    end

    add_index :audit_logs, [ :account_id, :created_at ]
    add_index :audit_logs, [ :target_type, :target_id ]
    add_index :audit_logs, :action
  end
end
