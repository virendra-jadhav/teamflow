class InvitationMailer < ApplicationMailer
  def invite(invitation)
    @invitation = invitation
    @account = invitation.account
    @inviter    = invitation.invited_by
    @accept_url = accept_invitation_url(
      invitation,
      token: invitation.token
    )

    mail(
      to: invitation.email,
      subject: "#{@inviter.name} invited you to #{@account.name}"
    )
  end
end
