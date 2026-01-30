require "rails_helper"
require "ostruct"

RSpec.describe MembershipPolicy do
  let(:account) { create(:account) }
  let(:admin)   { create(:user) }
  let(:member)  { create(:user) }

  let!(:admin_membership) do
    create(:membership, :admin, user: admin, account: account)
  end
  let!(:member_membership) do
    create(:membership, user: member, account: account)
  end

  subject { described_class }

  permissions :update?, :destroy? do
    it "allows admin" do
      expect(subject).to permit(
        OpenStruct.new(user: admin, account: account),
        member_membership
      )
    end

    it "denies member" do
      expect(subject).not_to permit(
        OpenStruct.new(user: member, account: account),
        admin_membership
      )
    end
  end

  permissions :destroy? do
  it "allows admin to remove member" do
    expect(subject).to permit(
      OpenStruct.new(user: admin, account: account),
      member_membership
    )
  end

  it "denies admin removing self" do
    expect(subject).not_to permit(
      OpenStruct.new(user: admin, account: account),
      admin_membership
    )
  end

  it "denies member" do
    expect(subject).not_to permit(
      OpenStruct.new(user: member, account: account),
      admin_membership
    )
  end
end
permissions :transfer_ownership? do
  it "allows admin" do
    expect(subject).to permit(
      OpenStruct.new(user: admin, account: account),
      member_membership
    )
  end

  it "denies member" do
    expect(subject).not_to permit(
      OpenStruct.new(user: member, account: account),
      admin_membership
    )
  end
end
  permissions :update_avatar?, :remove_avatar? do
    let!(:other_user) { create(:user) }

    it 'allow admin' do
      expect(subject).to permit(
        OpenStruct.new(user: admin, account: account),
        member_membership
      )
    end
    it "allow self update" do
      expect(subject).to permit(
        OpenStruct.new(user: member, account: account),
        member_membership
      )
    end
    it "member not update other" do
      expect(subject).not_to permit(
        OpenStruct.new(user: member, account: account),
        admin_membership
      )
    end
    it "other user not access" do
      expect(subject).not_to permit(
        OpenStruct.new(user: other_user, account: account),
        member_membership
      )
    end
  end
end
