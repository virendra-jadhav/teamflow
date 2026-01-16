# spec/services/invitations/accept_spec.rb
require "rails_helper"

RSpec.describe Invitations::Accept do
  let(:account) { create(:account) }
  let(:user) { create(:user, email: "test@example.com") }

  let(:invitation) do
    create(
      :invitation,
      account: account,
      email: user.email,
      expires_at: 2.days.from_now
    )
  end

  it "creates membership and marks invitation accepted" do
    result = described_class.new(invitation: invitation, user: user).call

    expect(result.success?).to be true
    expect(user.memberships.exists?(account: account)).to be true
    expect(invitation.reload.accepted?).to be true
  end

  it "prevents accepting twice" do
    invitation.update!(accepted_at: Time.current)

    result = described_class.new(invitation: invitation, user: user).call

    expect(result.success?).to be false
  end

  it "rejects expired invitation" do
    invitation.update!(expires_at: 1.day.ago)

    result = described_class.new(invitation: invitation, user: user).call

    expect(result.success?).to be false
  end
end
