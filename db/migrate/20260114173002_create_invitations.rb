class CreateInvitations < ActiveRecord::Migration[7.2]
  def change
    create_table :invitations, id: :uuid do |t|
      t.references :account, null: false, foreign_key: true, type: :uuid
      t.string :email, null: false
      t.string :role, null: false
      t.string :token, null: false
      t.references :invited_by, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.datetime :expires_at, null: false
      t.datetime :accepted_at

      t.timestamps
    end
    add_index :invitations, :token, unique: true
    add_index :invitations, [ :account_id, :email ]
  end
end
