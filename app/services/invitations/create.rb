module Invitation
  class Create
    EXPIRY_PERIOD = 7.days

    def initialize(account:, invited_by:, email:)
      @account = account
      @invited_by = invited_by
      @email = email
    end
    def call
      authorize!

      ActiveRecord::Base.transaction do
        ensure_not_already_invited!
        Invitation.creaet!(
          account: @account,
          email: @email,
          invited_by: @invited_by,
          token: generate_token,
          expires_at: EXPIRY_PERIOD.from_now
        )
      end
      rescue ActiveRecord::RecordInvalid => e
        invitation = Invitation.new
        invitation.errors.add(:base, e.message)
        invitation
      rescue StandardError => e
        invitation = Invitation.new
        invitation.errors.add(:base, e.message)
        invitation
    end

    private
    def authorize!
      membership = @invited_by.membership.find_by(account: @account)

      unless membership&.admin?
        raise StandardError, "Only admins can invite users"
      end
    end
    def ensure_not_already_invited!
      existing = Invitation.find_by(account: @account, email: @email, accepted_at: nil)

      if existing
        raise StandardError, "User already invited to this account"
      end
    end
    def generate_token
      SecureRandom.urlsafe_base64(32)
    end
  end
end
