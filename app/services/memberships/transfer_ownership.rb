module Memberships
  class TransferOwnership
    def initialize(account:, from:, to:)
      @account = account
      @from = from
      @to = to
    end
    def call
      return false if @from == @to

      from_membership = membership_for(@from)
      to_membership = membership_for(@to)

      return false unless from_membership&.admin?
      return false unless to_membership

      ActiveRecord::Base.transaction do
        from_membership.update!(role: "member")
        to_membership.update!(role: "admin")
      end

      true
    rescue ActiveRecord::RecordInvalid
      false
    end

    private
    def membership_for(user)
      Membership.find_by(user: user, account: @account)
    end
  end
end
