class AddNotNullToUsersEmail < ActiveRecord::Migration[7.2]
  def up
    execute <<~SQL
      UPDATE users
      SET email = 'invalid@example.com'
      WHERE email IS NULL
    SQL

    change_column_null :users, :email, false
  end

end
