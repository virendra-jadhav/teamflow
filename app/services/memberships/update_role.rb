module Memberships
  class UpdateRole
    VALID_ROLES = %w[admin member].freeze

    def initialize(membership:, role:)
      @membership = membership
      @role = role
    end

    def call
      return false unless VALID_ROLES.include?(@role)
      @membership.update(role: @role)
    end
  end
end
