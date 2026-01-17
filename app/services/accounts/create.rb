module Accounts
  class Create
    def initialize(user:, account_params:)
      @user = user
      @account_params = account_params
    end

    def call
      Account.transaction do
        account = Account.create!(@account_params)

        Membership.create!(
          user: @user,
          account: account,
          role: "admin"
        )

        account
      end
    rescue ActiveRecord::RecordInvalid => e
      account ||= Account.new(@account_params)
      account.errors.add(:base, e.message)
      account
    end
  end
end
