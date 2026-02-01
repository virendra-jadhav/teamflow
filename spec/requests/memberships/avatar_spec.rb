require "rails_helper"

RSpec.describe "Memberships::AvatarsController", type: :request do
  let(:account) { create(:account) }
  let(:admin) { create(:user) }
  let(:member) { create(:user) }

  let!(:admin_membership) do
    create(:membership, :admin, user: admin, account: account)
  end

  let!(:member_membership) do
    create(:membership, user: member, account: account)
  end

  let(:file) do
    fixture_file_upload(
      Rails.root.join("spec/fixtures/files/avatar.png"),
      "image/png"
    )
  end
  before do
    login_as admin
    post account_switch_path(account_id: account.id)
  end

  describe "PATCH /memberships/:membership_id/avatar" do
   it "allows admin to update avatar" do
     patch membership_avatar_path(member_membership), params: { avatar: file }

     expect(response).to redirect_to(accounts_settings_path)
     expect(member_membership.reload.avatar).to be_attached
   end
   it "prevents member from updating another member avatar" do
    login_as member
     patch membership_avatar_path(admin_membership), params: { avatar: file }

     expect(response).to have_http_status(:forbidden)
   end
  end

  describe "DELETE /memberships/:membership_id/avatar" do
    before do
      member_membership.avatar.attach(file)
    end
    it "allows admin to remove avatar" do
      delete membership_avatar_path(member_membership)

      expect(response).to redirect_to(accounts_settings_path)
      expect(member_membership.reload.avatar).not_to be_attached
    end

    it "prevents member from removing another avatar" do
      login_as member

      delete membership_avatar_path(admin_membership)
      expect(response).to have_http_status(:forbidden)
    end
  end
end
