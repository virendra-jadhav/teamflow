require "rails_helper"

RSpec.describe "User update without password", type: :request do
  let(:account) { create(:account) }

  let(:admin) do
    user = create(:user, confirmed_at: Time.current)
    create(:membership, :admin, user: user, account: account)
    user
  end

  let(:user) do
    user = create(:user, confirmed_at: Time.current)
    create(:membership, user: user, account: account)
    user
  end

  before do
    post login_path, params: { email: admin.email, password: "password" }
    post account_switch_path(account_id: account.id)
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
