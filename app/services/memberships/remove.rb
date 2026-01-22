module Memberships
  class Remove
    def initialize(membership:, actor:)
      @membership = membership
      @actor =  actor
      @account = membership.account
    end
    def call
      return false unless actor_admin?
      return false if self_removal?
      return false if last_admin?

      @membership.destroy
      true
    end

    private
    def actor_admin?
      Membership.exists?(
        user: @actor,
        account: @membership.account,
        role: "admin"
      )
    end
    def self_removal?
      @membership.user == @actor
    end

    def last_admin?
      @membership.admin? &&
      Membership.where(
        account: @account,
        role: "admin"
      ).count == 1
    end
  end
end
