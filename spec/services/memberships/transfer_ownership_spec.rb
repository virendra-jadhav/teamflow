require "rails_helper"

RSpec.describe Memberships::TransferOwnership do
  let!(:account) { create(:account) }
  let!(:old_admin) { create(:user) }
  let!(:new_admin) { create(:user) }
  let!(:member) { create(:user) }

  let!(:old_admin_membership) do
    create(:membership, :admin, user: old_admin, account: account)
  end
  let!(:new_admin_membership) do
    create(:membership, user: new_admin, account: account)
  end
  let!(:member_membership) do
    create(:membership, user: member, account: account)
  end

  subject do
    described_class.new(
      account: account,
      from: old_admin,
      to: new_admin
    )
  end

  it "transfers admin role to another member" do
    result = subject.call

    expect(result).to be true
    expect(old_admin_membership.reload.role).to eq("member")
    expect(new_admin_membership.reload.role).to eq("admin")
  end

  it "does not allow transfer by non-admin" do
    result = described_class.new(
      account: account,
      from: member,
      to: new_admin
    ).call

    expect(result).to be false
  end

  it "does not allow transfer to self" do
    result = described_class.new(
      account: account,
      from: old_admin,
      to: old_admin
    ).call
    expect(result).to be false
  end
end
