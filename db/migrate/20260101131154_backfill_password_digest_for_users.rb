class BackfillPasswordDigestForUsers < ActiveRecord::Migration[7.2]
  def up 
    User.where(password_digest: nil).find_each do |user|
      user.update_columns(
        # password_digest: BCrypt::Password.create(SecureRandom.hex(16)),
        password_digest: BCrypt::Password.create("user"),
        updated_at: Time.current
      )
    end
  end
  def down
    # irreversible on purpose
  end
end
