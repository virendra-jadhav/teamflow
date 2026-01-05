class UserMailer < ApplicationMailer
  def password_reset(user)
    @user = user
    @reset_url = edit_password_reset_url(user.reset_password_token)

    mail(
      to: user.email,
      subject: "Reset your password"
    )
  end
  def email_confirmation(user)
    @user = user
    @confirmation_url = confirm_email_url(token: user.confirmation_token)

    mail(
      to: user.email,
      subject: "Confirm your email"
    )
  end
  def unlock_account(user, token)
    @unlock_url = unlock_account_url(token: token, user_id: user.id)
    mail(
      to: user.email,
      subject: "Unlock your account "
    )
  end
end
