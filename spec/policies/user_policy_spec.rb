require "rails_helper"

RSpec.describe UserPolicy do
  let(:admin)  { User.new(role: "admin") }
  let(:member) { User.new(role: "member") }
  let(:record) { User.new }

  it "allows admin to destroy" do
    policy = described_class.new(admin, record)
    expect(policy.destroy?).to eq(true)
  end
end
