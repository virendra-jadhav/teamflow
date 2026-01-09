require "rails_helper"
RSpec.describe Users::Update do
  describe "#call" do
    let!(:user) do
      User.create!(
        name: "Old Name",
        email: "old@example.com",
        password: "password",
        password_confirmation: "password",
        confirmed_at: Time.current
      )
    end

    context "with valid email" do
      it "updates the email" do
        result = described_class.new(user, { email: "new@example.com" }).call

        expect(result).to eq(true)
        expect(user.reload.email).to eq("new@example.com")
      end
    end

    context "with invalid email" do
      it "does not update the email" do
        result = described_class.new(user, { email: "bad-email" }).call

        expect(result).to eq(false)
        expect(user.reload.email).to eq("old@example.com")
      end

      it "adds an email validation error" do
        described_class.new(user, { email: "bad-email" }).call
        expect(user.errors[:email]).to be_present
      end
    end
  end
end
