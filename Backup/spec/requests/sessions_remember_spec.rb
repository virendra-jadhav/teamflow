require "rails_helper"

RSpec.describe "Remember me", type: :request do
  let!(:user) do
    User.create!(
      name: "User",
      email: "remember@test.com",
      password: "password",
      password_confirmation: "password",
      role: "member",
      confirmed_at: Time.current
    )
  end

 it "persists login via cookies" do
    post login_path, params: {
      email: user.email,
      password: "password",
      remember_me: "1"
    }

    expect(cookies[:remember_user_id]).to be_present
    expect(cookies[:remember_token]).to be_present

    delete logout_path

    expect(cookies[:remember_user_id]).to be_blank
    expect(cookies[:remember_token]).to be_blank
  end
end
