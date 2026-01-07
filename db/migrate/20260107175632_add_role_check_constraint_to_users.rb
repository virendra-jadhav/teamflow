class AddRoleCheckConstraintToUsers < ActiveRecord::Migration[7.2]
  def up
    execute <<~SQL
      ALTER TABLE users
      ADD CONSTRAINT users_role_check
      CHECK (role IN ('member', 'admin'))
    SQL
  end

  def down
    execute <<~SQL
      ALTER TABLE users
      DROP CONSTRAINT users_role_check
    SQL
  end
end
