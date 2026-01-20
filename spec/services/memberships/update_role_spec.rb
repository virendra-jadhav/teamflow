require "rails_helper"


RSpec.describe Memberships::UpdateRole do
  let(:account) { create(:account) }
  let(:admin) { create(:user) }
  let(:member) { create(:user) }

  let!(:admin_membership) do
    create(:membership, :admin, user: admin, account: account)
  end
  let!(:member_membership) do
    create(:membership, user: member, account: account)
  end

  describe "#call" do
    context "with valid role" do
      it "updates the membership role" do
        result = described_class.new(
          membership: member_membership,
          role: "admin"
        ).call

        expect(result).to be true
        expect(member_membership.reload.role).to eq("admin")
      end
    end

    context "with invalid role" do
      it "does not update role" do
        result = described_class.new(
          membership: member_membership,
          role: "owner"
        ).call
        expect(result).to be false
        expect(member_membership.reload.role).to eq("member")
      end
    end

    context "when admin tries to demote themselves" do
      it "does not allow self demotion" do
        result = described_class.new(
          membership: admin_membership,
          role: "member"
        ).call

        expect(result).to be false
        expect(admin_membership.reload.role).to eq("admin")
      end
    end
  end
end
