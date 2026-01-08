module Accounts

  class Create 
    def initialize(user:, account_params:)
      @user = user,
      @account_params = account_params
    end
    def call
      account = nil

      ActiveRecord::Base.transaction do 
        account = Account.create!(@account_params)
        Membership.create!(
          user: @user,
          account: account,
          role: "admin"
        )
      end

      # side effect AFTER commit
      AccountMailer.account_created(@user, account).deliver_later

      account
    rescue ActiveRecord::RecordInvalid => e 
      Rails.logger.error(e.message)
      nil
    end
  end
end