require "rails_helper"

RSpec.describe "User role management", type: :request do
  let(:account) { create(:account) }

  let(:admin) do
    user = create(:user, confirmed_at: Time.current)
    create(:membership, :admin, user: user, account: account)
    user
  end

  let(:member) do
    user = create(:user, confirmed_at: Time.current)
    create(:membership, user: user, account: account)
    user
  end

  before do
    post login_path, params: { email: admin.email, password: "password" }

    # 🔑 MUST be set before every authorized request
    post account_switch_path(account_id: account.id)
  end

  it "allows admin to update role" do
    patch update_role_user_path(member), params: { role: "admin" }

    expect(response).to redirect_to(users_path)

    membership = member.memberships.find_by(account: account)
    expect(membership.admin?).to be true
  end
end
