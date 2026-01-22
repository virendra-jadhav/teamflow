require "rails_helper"

RSpec.describe AuditLog do
  it "is valid with valid attributes" do
    audit_log = create(:audit_log)
    expect(audit_log).to be_valid
  end

  it "requires an action" do
    audit_log = build(:audit_log, action: nil)
    expect(audit_log).not_to be_valid
  end
end
