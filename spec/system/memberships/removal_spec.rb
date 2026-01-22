require "rails_helper"

RSpec.describe "Membership removal", type: :system do
  let!(:account) { create(:account) }
  let!(:admin) { create(:user) }
  let!(:member) { create(:user) }

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
    it "allow admin to remove a member" do
      # accept_confirm do
      #   click_button "Remove"
      # end
      click_button "Remove"
      expect(page).to have_content("Member removed successfully")
      expect(page).not_to have_content(member.email)
    end
    it "does not allow admin to remove themselves" do
      # expect(page).not_to have_content("Remove", exact: false)
      within("tr", text: admin.email) do
        expect(page).not_to have_button("Remove")
      end
    end
  end

  context "as member" do
    before do
      login_as(member)
      visit account_switch_path(account_id: account.id)
      visit accounts_settings_path
    end
    it "does not show remove controls" do
      expect(page).not_to have_button("Remove")
    end
  end
end
