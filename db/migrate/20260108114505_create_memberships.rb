# db/migrate/20260107000200_create_memberships.rb
class CreateMemberships < ActiveRecord::Migration[7.2]
  def change
    create_table :memberships do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :account, null: false, foreign_key: true, type: :uuid
      t.string :role, null: false
      t.timestamps
    end

    # Prevent duplicate membership
    add_index :memberships, [:user_id, :account_id], unique: true

    # Enforce allowed roles
    execute <<~SQL
      ALTER TABLE memberships
      ADD CONSTRAINT memberships_role_check
      CHECK (role IN ('admin', 'member'))
    SQL
  end
end
