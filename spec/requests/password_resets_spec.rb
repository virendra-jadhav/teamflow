require "rails_helper"

RSpec.describe "Password reset", type: :request do
  let!(:user) do
    User.create!(
      name: "User",
      email: "user@test.com",
      password: "password",
      password_confirmation: "password",
      role: "member"
    )
  end

  it "generates reset token" do
    post password_resets_path, params: { email: user.email }

    user.reload
    expect(user.reset_password_token).to be_present
  end

  it "resets password using token" do
    token = user.generate_password_reset!

    patch password_reset_path(token), params: {
      user: {
        password: "newpassword",
        password_confirmation: "newpassword"
      }
    }

    expect(response).to redirect_to(login_path)
    expect(user.reload.authenticate("newpassword")).to be_truthy
  end
end
