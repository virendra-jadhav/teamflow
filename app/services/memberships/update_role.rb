# app/services/memberships/update_role.rb
module Memberships
  class UpdateRole
    VALID_ROLES = %w[admin member].freeze

    def initialize(membership:, role:, actor:)
      @membership = membership
      @role = role
      @actor = actor
    end

    def call
      return false unless VALID_ROLES.include?(@role)

      # prevent admin demoting themselves
      if self_demotion?
        return false
      end

      @membership.update(role: @role)
    end

    private

    def self_demotion?
      @membership.user == @actor &&
        @membership.admin? &&
        @role == "member"
    end
  end
end
