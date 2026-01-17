module Invitations
  class Create
    EXPIRY_PERIOD = 7.days

    def initialize(account:, invited_by:, email:, role: "member")
      @account = account
      @invited_by = invited_by
      @email = email
      @role = role
    end

    def call
      authorize!

      validate_role!

      invitation = nil

      ActiveRecord::Base.transaction do
        ensure_not_already_invited!

        invitation = Invitation.create!(
          account: @account,
          email: @email,
          role:        @role,
          invited_by: @invited_by,
          token: generate_token,
          expires_at: EXPIRY_PERIOD.from_now
        )
      end

      # ✅ EMAIL IS SENT AFTER COMMIT
      InvitationMailer.invite(invitation).deliver_later

      invitation
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
      membership = @invited_by.memberships.find_by(account: @account)

      unless membership&.admin?
        raise StandardError, "Only admins can invite users"
      end
    end

    def validate_role!
      unless Invitation::VALID_ROLES.include?(@role)
        raise StandardError, "Invalid role"
      end
    end

    def ensure_not_already_invited!
      existing = Invitation.find_by(
        account: @account,
        email: @email,
        accepted_at: nil
      )

      if existing
        raise StandardError, "User already invited to this account"
      end
      if @account.users.exists?(email: @email)
        raise StandardError, "User is already a member of this account"
      end
    end

    def generate_token
      SecureRandom.urlsafe_base64(32)
    end
  end
end
