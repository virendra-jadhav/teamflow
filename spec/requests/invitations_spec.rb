require "rails_helper"

RSpec.describe "Invatations", type: :request do
  let(:account) { create(:account) }
  let(:admin) do
    user = create(:user)
    create(:membership, :admin, user: user, account: account)
    user
  end
  before do
    post login_path, params: { email: admin.email, password: "password" }
    post account_switch_path(account_id: account.id)
  end

  it "allow admin to send invitation" do
    post invitations_path, params: {
      email: "new@test.com",
      role: "member"
    }
    expect(response).to redirect_to(invitations_path)
  end
end
