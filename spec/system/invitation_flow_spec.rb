require "rails_helper"

RSpec.describe "Invitation flow", type: :system do
  let(:account) { create(:account) }

  let(:admin) do
    user = create(:user, password: "password")
    create(:membership, :admin, user: user, account: account)
    user
  end

  let(:invitee) { create(:user, email: "invitee@email.com", password: "password") }
  it "invites and accepts user" do
    login_as(admin)
    visit account_switch_path(account_id: account.id)
    visit invitations_path

    fill_in "User email", with: invitee.email
    click_button "Send Invitation"

    invitation = Invitation.last
    click_button "Logout"


  # Login as invitee FIRST
  login_as(invitee)

  visit accept_invitation_path(invitation, token: invitation.token)
  click_button "Accept Invitation"

  expect(page).to have_content(account.name)
  end
end
