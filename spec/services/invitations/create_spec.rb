require "rails_helper"

RSpec.describe Invitations::Create do
  let(:account) { create(:account) }

  let(:admin) do
    user = create(:user)
    create(:membership, :admin, user: user, account: account)
    user
  end

  let(:member) do
    user = create(:user)
    create(:membership, user: user, account: account)
    user
  end

  let(:email) { "invitee@example.com" }

  describe "#call" do
    context "when inviter is admin" do
      it "creates an invitation" do
        result = described_class.new(
          account: account,
          invited_by: admin,
          email: email
        ).call

        expect(result).to be_persisted
        expect(result.email).to eq(email)
        expect(result.account).to eq(account)
        expect(result.invited_by).to eq(admin)
        expect(result.token).to be_present
        expect(result.expires_at).to be > Time.current
      end
    end

    context "when inviter is not admin" do
      it "does not create invitation" do
        result = described_class.new(
          account: account,
          invited_by: member,
          email: email
        ).call

        expect(result).not_to be_persisted
        expect(result.errors[:base]).to include("Only admins can invite users")
      end
    end

    context "when email already invited" do
      before do
        create(
          :invitation,
          account: account,
          email: email,
          accepted_at: nil
        )
      end

      it "does not allow duplicate active invitation" do
        result = described_class.new(
          account: account,
          invited_by: admin,
          email: email
        ).call

        expect(result).not_to be_persisted
        expect(result.errors[:base]).to include("User already invited to this account")
      end
    end

    context "when email is invalid" do
      it "fails validation" do
        result = described_class.new(
          account: account,
          invited_by: admin,
          email: ""
        ).call

        expect(result).not_to be_persisted
        expect(result.errors).to be_present
      end
    end
  end
end
