class RemoveRoleFromUsers < ActiveRecord::Migration[7.2]
  def up
    remove_column :users, :role, :string
  end
  def down 
    add_column :users, :role, :string, null: false, default: "member"
  end
end
