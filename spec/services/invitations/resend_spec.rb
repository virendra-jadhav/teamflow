require "rails_helper"

RSpec.describe Invitations::Resend do
  let(:invitation) { create(:invitation) }
  let(:admin) { create(:user) }

  subject { described_class }

  it "resends invitation" do
    result = subject.new(
      invitation: invitation,
      resent_by: admin
    ).call

    expect(result.success?).to be true
  end
  it "invalid if already accepted" do
    invitation.update!(accepted_at: Time.current)

    result = subject.new(invitation: invitation, resent_by: admin).call
    expect(result.success?).to be false
    expect(result.error).to include("Invatation already accepted")
  end

  it "invalid if invitation expired" do
    invitation.update!(expires_at: 1.days.ago)

    result = subject.new(invitation: invitation, resent_by: admin).call
    expect(result.success?).to be false
    # expect(result.errors[:base]).to include("Invitation already accepted")
    expect(result.error).to include("Invatation is expired")
  end
end
