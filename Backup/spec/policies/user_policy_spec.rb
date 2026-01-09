require "rails_helper"

RSpec.describe UserPolicy do
  let(:admin) do
    User.new(role: "admin")
  end

  let(:member) do
    User.new(role: "member")
  end

  let(:other_user) do
    User.new(role: "member")
  end

  subject { described_class }

  describe "#index?" do
    it "allows admin" do
      policy = subject.new(admin, User)
      expect(policy.index?).to eq(true)
    end

    it "denies member" do
      policy = subject.new(member, User)
      expect(policy.index?).to eq(false)
    end
  end

  describe "#create?" do
    it "allows admin" do
      policy = subject.new(admin, User)
      expect(policy.create?).to eq(true)
    end

    it "denies member" do
      policy = subject.new(member, User)
      expect(policy.create?).to eq(false)
    end
  end

  describe "#update?" do
    it "allows admin to update anyone" do
      policy = subject.new(admin, other_user)
      expect(policy.update?).to eq(true)
    end

    it "allows member to update self" do
      policy = subject.new(member, member)
      expect(policy.update?).to eq(true)
    end

    it "denies member updating others" do
      policy = subject.new(member, other_user)
      expect(policy.update?).to eq(false)
    end
  end

  describe "#destroy?" do
    it "allows admin" do
      policy = subject.new(admin, other_user)
      expect(policy.destroy?).to eq(true)
    end

    it "denies member" do
      policy = subject.new(member, other_user)
      expect(policy.destroy?).to eq(false)
    end
  end
end
