require "rails_helper"

RSpec.describe Memberships::ProcessAvatarJob, type: :job do
  let(:membership) { create(:membership) }
  let(:file) {
    fixture_file_upload(Rails.root.join("spec/fixtures/files/avatar.png"), "image/png")
   }
   before do
     membership.avatar.attach(file)
   end

   it "processes the avatar variant safely" do
     expect {
      described_class.perform_now(membership.id)
     }.not_to raise_error
   end

   it "does nothing if membership is missing" do
     expect {
      described_class.perform_now("missing-id")
     }.not_to raise_error
   end
end
