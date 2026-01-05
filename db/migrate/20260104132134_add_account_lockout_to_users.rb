class AddAccountLockoutToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :failed_attempts, :integer, default: 0, null: false
    add_column :users, :locked_at, :datetime
    add_column :users, :unlock_token_digest, :string

    add_index :users, :unlock_token_digest
  end
end
