require "rails_helper"

RSpec.describe "Users Auth", type: :request do
  let!(:account) { create(:account) }

  let!(:admin) { create(:user, confirmed_at: Time.current) }
  let!(:member) { create(:user, confirmed_at: Time.current) }
  let!(:target_user) { create(:user, confirmed_at: Time.current) }

  before do
    create(:membership, :admin, user: admin, account: account)
    create(:membership, user: member, account: account)
    create(:membership, user: target_user, account: account)
  end

  # GET /users
  describe "GET /users" do
    context "as admin" do
      before do
        post login_path, params: { email: admin.email, password: "password" }
        post account_switch_path(account_id: account.id)
      end
      it "returns success" do
        get users_path
        expect(response).to have_http_status(:ok)
      end
    end
    context "as member" do
      before do
        post login_path, params: { email: member.email, password: "password" }
        post account_switch_path(account_id: account.id)
      end
      it "returns forbidden" do
        get users_path
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  # Patch /users/:id
  describe "PATCH /users/:id" do
    context "as admin" do
      before do
        post login_path, params: { email: admin.email, password: "password" }
        post account_switch_path(account_id: account.id)
      end
      it "updates user without changing password" do
        old_password_digest = target_user.password_digest

        patch user_path(target_user), params: {
          user: { name: "Updated Name" }
        }

        expect(response).to redirect_to(edit_user_path(target_user))
        expect(target_user.reload.name).to eq("Updated Name")
        expect(target_user.password_digest).to eq(old_password_digest)
      end
    end
    context "as member" do
      before do
        post login_path, params: { email: member.email, password: "password" }
        post account_switch_path(account_id: account.id)
      end
      it "cannot update another user" do
        patch user_path(target_user), params: {
          user: { name: "Hacked" }
        }

        expect(response).to have_http_status(:forbidden)
        expect(target_user.reload.name).not_to eq("Hacked")
      end
    end
  end



  # let!(:admin) do
  #   User.create!(
  #     name: "Admin",
  #     email: "admin@test.com",
  #     password: "password",
  #     password_confirmation: "password",
  #     role: "admin",
  #     confirmed_at: Time.current
  #   )
  # end

  # let!(:member) do
  #   User.create!(
  #     name: "Member",
  #     email: "member@test.com",
  #     password: "password",
  #     password_confirmation: "password",
  #     role: "member",
  #     confirmed_at: Time.current
  #   )
  # end

  # let!(:target_user) do
  #   User.create!(
  #     name: "Target",
  #     email: "target@test.com",
  #     password: "password",
  #     password_confirmation: "password",
  #     role: "member",
  #     confirmed_at: Time.current
  #   )
  # end

  # # ---------------------------
  # # GET /users
  # # ---------------------------
  # describe "GET /users" do
  #   context "as admin" do
  #     before do
  #       post login_path, params: { email: admin.email, password: "password" }
  #     end

  #     it "returns success" do
  #       get users_path
  #       expect(response).to have_http_status(:ok)
  #     end
  #   end

  #   context "as member" do
  #     before do
  #       post login_path, params: { email: member.email, password: "password" }
  #     end

  #     it "returns forbidden" do
  #       get users_path
  #       # expect(response).to have_http_status(:forbidden)
  #       # expect(response).to redirect_to(users_path)
  #       expect(response).to have_http_status(:forbidden)
  #     end
  #   end
  # end

  # # ---------------------------
  # # PATCH /users/:id
  # # ---------------------------
  # describe "PATCH /users/:id" do
  #   context "as admin" do
  #     before do
  #       post login_path, params: { email: admin.email, password: "password" }
  #     end

  #     it "updates user without changing password" do
  #       old_password_digest = target_user.password_digest

  #       patch user_path(target_user), params: {
  #         user: { name: "Updated Name" }
  #       }

  #       expect(response).to redirect_to(edit_user_path(target_user))
  #       expect(target_user.reload.name).to eq("Updated Name")
  #       expect(target_user.password_digest).to eq(old_password_digest)
  #     end
  #   end

  #   context "as member" do
  #     before do
  #       post login_path, params: { email: member.email, password: "password" }
  #     end

  #     it "cannot update another user" do
  #       patch user_path(target_user), params: {
  #         user: { name: "Hacked" }
  #       }

  #       # expect(response).to have_http_status(:forbidden)
  #       # expect(target_user.reload.name).not_to eq("Hacked")
  #       # expect(response).to redirect_to(users_path)
  #       expect(response).to have_http_status(:forbidden)
  #       expect(target_user.reload.name).not_to eq("Hacked")
  #     end
  #   end
  # end
end
