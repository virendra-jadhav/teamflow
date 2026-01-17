require 'rails_helper'

RSpec.describe Invitation, type: :model do
  let(:account) { create(:account) }
  let(:admin) { create(:user) }

  it "is valid with valid attributes" do
    invitation = described_class.new(
      account: account,
      invited_by: admin,
      email: "invitee@email.com",
      role: "member",
      token: SecureRandom.urlsafe_base64,
      expires_at: 2.days.from_now
    )
    expect(invitation).to be_valid
  end
  it "is unusable if expired" do
    invitation = create(:invitation, expires_at: 1.hour.ago)
    expect(invitation).to be_expired
    expect(invitation).not_to be_usable
  end
  it "is unusable if already accepted" do
    invitation = create(:invitation, accepted_at: Time.current)
    expect(invitation).to be_accepted
    expect(invitation).not_to be_usable
  end
  it "rejects invalid role" do
    inv = build(:invitation, role: "owner")
    expect(inv).not_to be_valid
  end
end
