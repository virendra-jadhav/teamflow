class EmailConfirmationsController < ApplicationController
  skip_before_action :require_login
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    puts "user is : #{user}"
    puts "is confirmed: #{user.confirmed?}"
    if user && !user.confirmed?
      user.regenerate_confirmation!
      
      UserMailer.email_confirmation(user).deliver_later
    end
    redirect_to login_path, notice: "If your email exists, confirmation instructions were sent."
  end

  def edit
    user = User.find_by(confirmation_token: params[:token])

    if user.nil? || user.confirmation_expired?
      redirect_to login_path, alert: "confirmation link expired."
      return
    end
    user.confirm!
    redirect_to login_path, notice: "Email confirmed, Please log in."
  end
end
