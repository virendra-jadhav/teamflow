
require "rails_helper"
RSpec.describe "User role management", type: :request do
  let!(:admin) { create(:user, role: :admin) }
  let!(:member) { create(:user, role: :member) }

  context "as admin" do
    before { login_as(admin) }

    it "updates role" do
      patch update_role_user_path(member), params: { role: "admin" }

      expect(response).to redirect_to(users_path)
      expect(member.reload.admin?).to be true
    end
  end

  context "as member" do
    before { login_as(member) }

    it "is forbidden" do
      patch update_role_user_path(admin), params: { role: "member" }

      expect(response).to have_http_status(:forbidden)
    end
  end
end
