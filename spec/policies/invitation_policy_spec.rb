require "rails_helper"
require "ostruct"

RSpec.describe InvitationPolicy do
  let!(:account) { create(:account) }
  let!(:admin) { create(:user) }
  let!(:member) { create(:user) }
  let!(:invitation) { create(:invitation, account: account) }

  before do
    create(:membership, :admin, account: account, user: admin)
    create(:membership, account: account, user: member)
  end

  subject(:policy) { described_class }

  permissions :index?, :create?, :resend?, :revoke? do
    context "when user is admin" do
      let(:pundit_user) { OpenStruct.new(user: admin, account: account) }

      it "permits access" do
        expect(policy).to permit(pundit_user, invitation)
      end
    end

    context "when user is member" do
      let(:pundit_user) { OpenStruct.new(user: member, account: account) }

      it "denies access" do
        expect(policy).not_to permit(pundit_user, invitation)
      end
    end
  end
end
