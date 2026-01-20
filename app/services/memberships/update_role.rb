module Memberships
  class UpdateRole
    VALID_ROLES = %w[admin member].freeze

    def initialize(membership:, role:, actor:)
      @membership = membership
      @role = role
      @actor = actor
    end

    def call(current_user:)
      return false unless VALID_ROLES.include?(@role)

      # prevent admin demoting themselves
      if @membership.user == @actor &&
         @membership.admin? &&
         @role == "member"
        return false
      end

      @membership.update(role: @role)
    end
  end
end
