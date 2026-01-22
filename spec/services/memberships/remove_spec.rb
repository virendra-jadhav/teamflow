require "rails_helper"

RSpec.describe Memberships::Remove do
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
    context "when admin remove a member" do
      it "removes the membership" do
        result = described_class.new(
          membership: member_membership,
          actor: admin
        ).call
        expect(result).to be true
        expect(Membership.exists?(member_membership.id)).to be false
      end


  it "prevents removing last admin" do
    result = described_class.new(
      membership: admin_membership,
      actor: admin
    ).call

    expect(result).to be false
  end
    end

    context "when admin tries to remove themselves" do
      it "does not allow self removal" do
        result = described_class.new(
          membership: admin_membership,
          actor: admin
        ).call
        expect(result).to be false
        expect(Membership.exists?(admin_membership.id)).to be true
      end
    end
    context "when member tries to remove someone" do
      it "does not allow removal" do
        result = described_class.new(
          membership: member_membership,
          actor: member
        ).call

        expect(result).to be false
        expect(Membership.exists?(member_membership.id)).to be true
      end
    end
  end
end
