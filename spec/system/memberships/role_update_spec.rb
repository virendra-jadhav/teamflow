require "rails_helper"

RSpec.describe "Membership role update", type: :system do
  let!(:account) { create(:account) }
  let!(:admin) { create(:user, password: "password") }
  let!(:member) { create(:user, password: "password") }

  let!(:admin_membership) do
    create(:membership, :admin, user: admin, account: account)
  end
  let!(:member_membership) do
    create(:membership, user: member, account: account)
  end

  context "as admin" do
    before do
      login_as(admin)
      visit account_switch_path(account_id: account.id)
      visit accounts_settings_path
    end

    it "allows admin to promote a member" do
      expect {
        click_button "Make Admin"
      }.to change {
        member_membership.reload.role
      }.from("member").to("admin")
      expect(page).to have_content("Role updated successfully!")
    end
    it "does not allow admin to demote themselves" do
       # expect(page).not_to have_button("Make Member", exact: false)
       # within("tr", text: admin.email) do
       #   expect(page).not_to have_button("Make Member")
       # end
       within("tr", text: admin.email) do
        expect(page).not_to have_button("Make Member")
        expect(page).not_to have_button("Make Admin")
      end
    end
  end
  context "as member" do
    before do
      login_as(member)
      visit account_switch_path(account_id: account.id)
      visit accounts_settings_path
    end

    it "does not show role update controls" do
      expect(page).not_to have_button("Make Admin")
      expect(page).not_to have_button("Make Member")
    end
  end
end
