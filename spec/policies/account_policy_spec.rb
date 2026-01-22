require "rails_helper"

RSpec.describe AccountPolicy do
  let(:account) { create(:account) }
  let(:admin)   { create(:user) }
  let(:member)  { create(:user) }

  subject(:policy) do
    described_class.new(
      OpenStruct.new(user: user, account: account),
      account
    )
  end

  context "when user is an admin" do
    let(:user) { admin }

    context "with multiple members" do
      before do
        create(:membership, :admin, user: admin, account: account)
        create(:membership, user: member, account: account)
      end

      it "allows show" do
        expect(policy.show?).to eq(true)
      end

      it "allows update" do
        expect(policy.update?).to eq(true)
      end

      it "denies destroy" do
        expect(policy.destroy?).to eq(false)
      end
    end

    context "when admin is the sole member" do
      before do
        create(:membership, :admin, user: admin, account: account)
      end

      it "allows show" do
        expect(policy.show?).to eq(true)
      end

      it "allows update" do
        expect(policy.update?).to eq(true)
      end

      it "allows destroy" do
        expect(policy.destroy?).to eq(true)
      end
    end
  end

  context "when user is a regular member" do
    let(:user) { member }

    before do
      create(:membership, :admin, user: admin, account: account)
      create(:membership, user: member, account: account)
    end

    it "denies show" do
      expect(policy.show?).to eq(false)
    end

    it "denies update" do
      expect(policy.update?).to eq(false)
    end

    it "denies destroy" do
      expect(policy.destroy?).to eq(false)
    end
  end

  context "when user has no membership" do
    let(:user) { create(:user) }

    it "denies all actions" do
      expect(policy.show?).to eq(false)
      expect(policy.update?).to eq(false)
      expect(policy.destroy?).to eq(false)
    end
  end
end
