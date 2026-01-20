require "rails_helper"

RSpec.describe AccountPolicy do
  let(:account) { create(:account) }
  let(:admin)   { create(:user) }
  let(:member)  { create(:user) }

  before do
    create(:membership, :admin, user: admin, account: account)
    create(:membership, user: member, account: account)
  end

  context "as admin" do
    subject(:policy) do
      described_class.new(
        OpenStruct.new(user: admin, account: account),
        account
      )
    end

    it "allows update" do
      expect(policy.update?).to eq(true)
    end

    it "allows destroy" do
      expect(policy.destroy?).to eq(true)
    end
  end

  context "as member" do
    subject(:policy) do
      described_class.new(
        OpenStruct.new(user: member, account: account),
        account
      )
    end

    it "denies update" do
      expect(policy.update?).to eq(false)
    end

    it "denies destroy" do
      expect(policy.destroy?).to eq(false)
    end
  end
end
