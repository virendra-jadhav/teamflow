require "rails_helper"
require "ostruct"

RSpec.describe UserPolicy do
  let(:account) { create(:account) }
  let(:record)  { User.new }

  subject(:policy) { described_class }

  context "admin member" do
    let(:user) { create(:user) }

    before do
      create(:membership, :admin, user: user, account: account)
    end

    permissions :index?, :create? do
      it "allows access" do
        expect(policy).to permit(
          OpenStruct.new(user: user, account: account),
          record
        )
      end
    end
  end

  context "regular member" do
    let(:user) { create(:user) }

    before do
      create(:membership, user: user, account: account)
    end

    permissions :index?, :create? do
      it "denies access" do
        expect(policy).not_to permit(
          OpenStruct.new(user: user, account: account),
          record
        )
      end
    end
  end
end




# require "rails_helper"

# RSpec.describe UserPolicy do
#   let(:account) { create(:account) }
#   let(:record)  { User.new }

#   subject(:policy) { described_class }

#   context "when user is admin of account" do
#     let(:user) { create(:user) }

#     before do
#       create(:membership, :admin, user: user, account: account)
#     end

#     permissions :index?, :create? do
#       it "allows access" do
#         expect(policy).to permit(user, record, account: account)
#       end
#     end
#   end

#   context "when user is member of account" do
#     let(:user) { create(:user) }

#     before do
#       create(:membership, user: user, account: account)
#     end

#     permissions :index?, :create? do
#       it "denies access" do
#         expect(policy).not_to permit(user, record, account: account)
#       end
#     end
#   end
# end



# require "rails_helper"

# RSpec.describe UserPolicy do
#   let(:account) { create(:account) }
#   let(:record) { User.new }


#   subject(:policy) { described_class }

#   context "when user is admin of account" do
#     let(:user) { create(:user) }

#     before do
#       create(:membership, :admin, user: user, account: account)
#     end
#     it "allow index" do
#       expect(policy).to permit(user, record)
#     end
#     it "allow create" do
#       expect(policy).to permit(user, record)
#     end
#   end
#   context "when user is member of account" do
#     let(:user) { create(:user) }

#     before do
#       create(:membership, user: user, account: account)
#     end

#     it "denies index" do
#       expect(policy).not_to permit(user, record)
#     end

#     it "denies create" do
#       expect(policy).not_to permit(user, record)
#     end
#   end
# end
