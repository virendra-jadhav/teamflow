module Users
  class UpdateRole
    VALID_ROLES = %w[member admin].freeze

    def initialize(user, account, role)
      @user    = user
      @account = account
      @role    = role
    end

    def call
      return false unless VALID_ROLES.include?(@role)

      membership = @user.memberships.find_by(account: @account)
      return false unless membership

      membership.update(role: @role)
    end
  end
end
