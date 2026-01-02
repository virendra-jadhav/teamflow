require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let!(:user) do
    User.create!(
      name: "User",
      email: "user@test.com",
      password: "password",
      password_confirmation: "password",
      role: "member"
    )
  end

  describe "GET /login" do
    it "renders login page" do
      get login_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /login" do
    it "logs in the user" do
      post login_path, params: {
        email: user.email,
        password: "password"
      }

      expect(response).to redirect_to(users_path)
    end

    it "fails with invalid credentials" do
      post login_path, params: {
        email: user.email,
        password: "wrong-password"
      }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "DELETE /logout" do
    before do
      post login_path, params: {
        email: user.email,
        password: "password"
      }
    end

    it "logs out the user" do
      delete logout_path
      expect(response).to redirect_to(login_path)
    end
  end
end
