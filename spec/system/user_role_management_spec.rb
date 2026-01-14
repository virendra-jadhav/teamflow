require "rails_helper"

RSpec.describe "User role management UI", type: :system do
  let!(:account) { create(:account) }

  let!(:admin) do
    user = create(:user, password: "password")
    create(:membership, :admin, user: user, account: account)
    user
  end

  let!(:member) do
    user = create(:user, password: "password")
    create(:membership, user: user, account: account)
    user
  end

  context "when logged in as admin" do
    before do
      login_as(admin)

      visit root_path
      select account.name, from: "account_id"
      click_button "Switch Account"

      visit users_path
    end

    it "shows role management controls" do
      expect(page).to have_button("Update Role")
    end
  end

  context "when logged in as member" do
    before do
      login_as(member)

      visit root_path
      select account.name, from: "account_id"
      click_button "Switch Account"

      visit users_path
    end

    it "does not show role management controls" do
      expect(page).not_to have_button("Update Role")
    end
  end
end
