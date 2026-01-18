require "rails_helper"

RSpec.describe "Accounts Settings", type: :request do
  let(:account) { create(:account, name: "Old Name") }
  let(:admin) { create(:user) }
  let(:member) { create(:user) }

  before do
    create(:membership, :admin, user: admin, account: account)
    create(:membership,  user: member, account: account)
  end

  def login(user)
    post login_path, params: {
      email: user.email,
      password: "password"
    }
    session[:current_account_id] = account.id
  end
  describe "GET /accounts/settings" do
    it "allows admin access" do
      login(admin)

      get accounts_settings_path

      expect(response).to have_http_status(:ok)
    end

    it "denies member access" do
      login(member)

      get accounts_settings_path

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "PATCH /accounts/settings" do
    it "allows admin to update account name" do
      login(admin)
      patch accounts_settings_path, params: {
        account: { name: "New Name" }
      }
      expect(response).to redirect_to(accounts_settings_path)
      expect(account.reload.name).to eq("New Name")
    end
    it "prevents member from updating" do
      login(member)

      patch accounts_settings_path, params: {
        account: { name: "New Name" }
      }

      expect(response).to have_http_status(:forbidden)
      expect(account.reload.name).to eq("Old Name")
    end
  end
  describe "DELETE /accounts/settings"  do
    it "allow admin to delete account" do
      login(admin)
      expect {
        delete accounts_settings_path
      }.to change(Account, :count).by(-1)

      expect(session[:current_account_id]).to be_nil
    end
    it "prevents member from deleting account" do
      login(member)

      expect {
        delete accounts_settings_path
      }.not_to change(Account, :count)

      expect(response).to have_http_status(:forbidden)
    end
  end
end
