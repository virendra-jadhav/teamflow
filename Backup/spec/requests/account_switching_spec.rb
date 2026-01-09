require "rails_helper"

RSpec.describe "Account switching", type: :request do
  let(:user) { create(:user) }
  let(:account) { create(:account) }

  before do
    create(:membership, user: user, account: account)
    login_as(user)
  end
  it "store account id in session if user is a member" do
    post account_switch_path(account_id: account.id)

    expect(session[:current_account_id]).to eq(account.id)
  end
  it "does not allow switching to an account without membership" do
    other_account =  create(:account)

    post account_switch_path(account_id: other_account.id)

    expect(session[:current_account_id]).not_to eq(other_account.id)
  end
end
