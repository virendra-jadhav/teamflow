# spec/system/accounts/settings_spec.rb
require "rails_helper"

RSpec.describe "Account Settings", type: :system do
  let!(:account) { create(:account, name: "Old Account Name") }
  let!(:admin)   { create(:user, password: "password") }
  let!(:member)  { create(:user, password: "password") }

  before do
    create(:membership, :admin, user: admin, account: account)
    create(:membership, user: member, account: account)
  end

  context "as admin" do
    before do
      login_as(admin)
      visit account_switch_path(account_id: account.id)
      visit accounts_settings_path
    end

    it "shows the account settings page" do
      expect(page).to have_content("Account Settings")
      expect(page).to have_field("account_name", with: "Old Account Name")
    end

    it "allows updating the account name" do
      fill_in "account_name", with: "New Account Name"
      click_button "Update Account"

      expect(page).to have_content("Account updated successfully")
      expect(account.reload.name).to eq("New Account Name")
    end

    it "allows deleting the account" do
      click_button "Delete Account"

      expect(page).to have_content("Account deleted.")
      expect(Account.exists?(account.id)).to be false
    end
  end

  context "as member" do
    before do
      login_as(member)
      visit account_switch_path(account_id: account.id)
      visit accounts_settings_path
    end

    it "does not allow access to settings page" do
      expect(page).to have_current_path(accounts_settings_path)
      expect(page).not_to have_content("Account Settings")
    end
  end
end
