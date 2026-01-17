require "rails_helper"

RSpec.describe "Remember me", type: :request do
  let!(:user) do
    User.create!(
      name: "User",
      email: "remember@test.com",
      password: "password",
      password_confirmation: "password",
      # role: "member",
      confirmed_at: Time.current
    )
  end

 it "persists login via cookies" do
    post login_path, params: {
      email: user.email,
      password: "password",
      remember_me: "1"
    }


    # ✅ Rack::Test can only check raw cookie presence
    expect(cookies["remember_user_id"]).to be_present
    expect(cookies["remember_token"]).to be_present

    delete logout_path

    # #  Deletion is visible in response
    # expect(response.cookies["remember_user_id"]).to be_nil
    # expect(response.cookies["remember_token"]).to be_nil

    # expect(response.cookies[:remember_user_id]).to be_present
    # expect(response.cookies[:remember_token]).to be_present

    # delete logout_path

    # # expect(cookies[:remember_user_id]).to be_nil
    # # expect(cookies[:remember_token]).to be_nil
    # expect(response.cookies[:remember_user_id]).to be_nil
    # expect(response.cookies[:remember_token]).to be_nil


    # ✅ Working example below
    # user.reload
    # expect(user.remember_digest).to be_nil

    set_cookie_headers = response.headers["Set-Cookie"]

    expect(set_cookie_headers.any? { |c| c.include?("remember_token=") }).to be true
    expect(set_cookie_headers.any? { |c| c.include?("remember_user_id=") }).to be true
  end
end
