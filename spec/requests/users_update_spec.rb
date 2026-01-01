require "rails_helper"

RSpec.describe "User update without password", type: :request do
  let!(:admin) do
    User.create!(
      name: "Admin",
      email: "admin2@test.com",
      password: "password",
      password_confirmation: "password",
      role: "admin"
    )
  end

  let!(:user) do
    User.create!(
      name: "User",
      email: "user@test.com",
      password: "password",
      password_confirmation: "password",
      role: "member"
    )
  end

  before do
    post login_path, params: { email: admin.email, password: "password" }
  end

  it "updates user without changing password" do
    old_password_digest = user.password_digest

    patch user_path(user), params: {
      user: {
        name: "New Name",
        email: "new@email.com"
      }
    }

    expect(response).to redirect_to(edit_user_path(user))
    expect(user.reload.name).to eq("New Name")
    expect(user.password_digest).to eq(old_password_digest)
  end
end
