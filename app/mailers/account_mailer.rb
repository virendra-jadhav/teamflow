class AccountMailer < ApplicationMailer
  def account_created(user, account)
    @user = user
    @account = account 

    mail(
      to: @user.email,
      subject: "Your account #{@account.name} is ready!"
    )
  end
end
