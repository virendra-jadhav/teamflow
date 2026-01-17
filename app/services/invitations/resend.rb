module Invitations
  class Resend
    Result = Struct.new(:success?, :error)

    def initialize(invitation:, resent_by:)
      @invitation = invitation
      @resent_by = resent_by
    end

    def call
      return failure("Invatation already accepted") if @invitation.accepted?
      return failure("Invatation is expired") if @invitation.expired?

      InvitationMailer.invite(@invitation).deliver_later

      Result.new(true, nil)
    rescue => e
      Resule.new(false, e.message)
    end

    private
    def failure(msg)
      Result.new(false, msg)
    end
  end
end
