require "rails_helper"
require "ostruct"

RSpec.describe Memberships::UpdateAvatar do
  let(:account) { create(:account) }
  let(:admin)   { create(:user) }
  let(:member)  { create(:user) }

  let!(:admin_membership) do
    create(:membership, :admin, user: admin, account: account)
  end

  let!(:member_membership) do
    create(:membership, user: member, account: account)
  end

  let(:actor) { OpenStruct.new(user: admin, account: account) }

  let(:file) do
    fixture_file_upload(
      Rails.root.join("spec/fixtures/files/avatar.png"),
      "image/png"
    )
  end

  subject do
    described_class.new(
      actor: actor,
      membership: member_membership,
      file: file
    )
  end

  describe "#call" do
    context "when authorized and valid file" do
      before do
        allow(file).to receive(:content_type).and_return("image/png")
        allow(file).to receive(:size).and_return(100.kilobytes)
      end

      it "attaches avatar to membership" do
        subject.call
        expect(member_membership.avatar).to be_attached
      end
    end

    # context "when user is not authorized" do
    #   let(:actor) { OpenStruct.new(user: member, account: account) }

    #   before do
    #     allow(file).to receive(:content_type).and_return("image/png")
    #     allow(file).to receive(:size).and_return(100.kilobytes)
    #   end

    #   it "raises Pundit::NotAuthorizedError" do
    #     expect {
    #       subject.call
    #     }.to raise_error(Pundit::NotAuthorizedError)
    #   end
    # end
    context "when user is not authorized" do
      let(:actor) { OpenStruct.new(user: member, account: account) }

      subject do
        described_class.new(
          actor: actor,
          membership: admin_membership, # 👈 NOT their own
          file: file
        )
      end

      before do
        allow(file).to receive(:content_type).and_return("image/png")
        allow(file).to receive(:size).and_return(100.kilobytes)
      end

      it "raises Pundit::NotAuthorizedError" do
        expect {
          subject.call
        }.to raise_error(Pundit::NotAuthorizedError)
      end
    end


    context "when file is missing" do
      let(:file) { nil }

      it "raises service error" do
        expect {
          subject.call
        }.to raise_error(
          Memberships::UpdateAvatar::Error,
          "File is required"
        )
      end
    end

    context "when file type is invalid" do
      before do
        allow(file).to receive(:content_type).and_return("text/plain")
        allow(file).to receive(:size).and_return(100.kilobytes)
      end

      it "raises service error" do
        expect {
          subject.call
        }.to raise_error(
          Memberships::UpdateAvatar::Error,
          "Invalid file type"
        )
      end
    end

    context "when file size is too large" do
      before do
        allow(file).to receive(:content_type).and_return("image/png")
        allow(file).to receive(:size).and_return(10.megabytes)
      end

      it "raises service error" do
        expect {
          subject.call
        }.to raise_error(
          Memberships::UpdateAvatar::Error,
          /exceeds limit/
        )
      end
    end
  end
end



# require 'rails_helper'
# require "ostruct"


# RSpec.describe Memberships::UpdateAvatar do
#   let(:account) { create(:account) }
#   let(:admin) { create(:user) }
#   let(:member) { create(:user) }

#   let!(:admin_membership) do
#     create(:membership, :admin, user: admin, account: account)
#   end
#   let!(:member_membership) do
#     create(:membership, user: member, account: account)
#   end
#   let(:actor) { OpenStruct.new(user: admin, account: account) }

#   let(:file) {
#     fixture_file_upload(
#       Rails.root.join("spec/fixtures/files/avatar.png"),
#      'image/png'
#     )
#   }
#   subject do
#     described_class.new(actor: actor, membership: member_membership, file: file)
#   end
#   describe "#call" do
#     context "when authorized and valid file" do
#       it "attaches avatar to membership" do
#         subject.call
#         expect(member_membership.avatar).to be_attached
#       end
#     end
#     context "when user is not authorized" do
#       let(:actor) { OpenStruct.new(user: member, account: account) }
#       it "raises Pundit::NotAuthorizedError" do
#         expect {
#           subject.call
#         }.to raise_error(Pundit::NotAuthorizedError)
#       end
#     end
#     context "when file is missing" do
#       let(:file) { nil }
#       it "raises service error" do
#         expect {
#           subject.call
#         }.to raise_error(Memberships::UpdateAvatar::Error, "File is required")
#       end
#     end
#     context "when file type is invalid" do
#       let(:file) {
#         fixture_file_upload(
#           Rails.root.join("spec/fixtures/files/document.txt"),
#           'text/plain'
#         )
#       }
#       it "raises service error" do
#         expect {
#           subject.call
#         }.to raise_error(Memberships::UpdateAvatar::Error, "Invalid file type")
#       end
#     end
#     context "when file size is too large" do
#       before do
#         allow(file).to receive(:size).and_return(10.megabytes)
#       end
#       it "raises service error" do
#         expect {
#           subject.call
#         }.to raise_error(Memberships::UpdateAvatar::Error, /exceeds limit/)
#       end
#     end
#   end
# end
