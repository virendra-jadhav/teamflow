require "rails_helper"

RSpec.describe "Membership ownership transfer", type: :system do
  let!(:account) { create(:account) }
  let!(:admin) { create(:user) }
  let!(:member) { create(:user) }

  let!(:admin_membership) do
    create(:membership, :admin, user: admin, account: account)
  end

  let!(:member_membership) do
    create(:membership, user: member, account: account)
  end

  before do
    login_as(admin)
    visit account_switch_path(account_id: account.id)
    visit accounts_settings_path
  end

  it "allow admin to transfer ownership" do
    click_button "Transfer Ownership"

     expect(page).to have_content("Ownership transferred successfully")
    expect(member_membership.reload.role).to eq("admin")
    expect(admin_membership.reload.role).to eq("member")
  end
end
