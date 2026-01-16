# app/services/invitations/accept.rb
module Invitations
  class Accept
    Result = Struct.new(:success?, :error)

    def initialize(invitation:, user:)
      @invitation = invitation
      @user = user
    end

    def call
      return failure("Invitation already accepted") if @invitation.accepted?
      return failure("Invitation expired") if @invitation.expired?
      return failure("Email mismatch") if @user.email != @invitation.email

      ActiveRecord::Base.transaction do
        Membership.create!(
          user: @user,
          account: @invitation.account,
          role: "member"
        )

        @invitation.update!(
          accepted_at: Time.current
        )
      end

      Result.new(true, nil)

    rescue ActiveRecord::RecordInvalid => e
      Result.new(false, e.message)
    end

    private

    def failure(message)
      Result.new(false, message)
    end
  end
end
