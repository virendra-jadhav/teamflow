require 'rails_helper'

RSpec.describe "Email Confirmations", type: :request do
  # describe "GET /index" do
  #   pending "add some examples (or delete) #{__FILE__}"
  # end
  let!(:user) do
    User.create!(
      name: "User",
      email: "user@test.com",
      password: "user",
      password_confirmation: "user"
    )
  end
  it "confirms email successfully" do
    token = user.confirmation_token
    get confirm_email_path(token: token)
    expect(response).to redirect_to(login_path)
    expect(user.reload.confirmed?).to be_truthy
  end
end
