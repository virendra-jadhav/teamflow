class AddNotNullToUsersName < ActiveRecord::Migration[7.2]
  # def change
  # end
  def up
    execute <<~SQL
      UPDATE users
      SET name='unknown'
      WHERE name IS NULL
    SQL

    change_column_null :users, :name, false
  end
  def down
    change_column_null :users, :name, true
  end
end
