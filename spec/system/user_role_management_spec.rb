require "rails_helper"

RSpec.describe "User role management UI", type: :system do
  let!(:admin)  { create(:user, role: :admin, password: "password") }
  let!(:member) { create(:user, role: :member, password: "password") }

  context "when logged in as admin" do
    before do
      login_as(admin)
      visit users_path
    end

    it "shows role management controls" do
      expect(page).to have_content("Users")
      expect(page).to have_link("Change Role")
    end
  end

  context "when logged in as member" do
    before do
      login_as(member)
      visit users_path
    end

    it "does not show role management controls" do
      expect(page).to have_content("Users")
      expect(page).not_to have_link("Change Role")
    end
  end
end
