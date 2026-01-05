class SessionsController < ApplicationController
  skip_before_action :require_login, only: [ :new, :create ]
  skip_before_action :verify_authenticity_token



  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.locked?
      flash.now[:alert] = "Account locked. check your email to unlock."
      render :new, status: :locked
      return
    end

    if user&.authenticate(params[:password])
       user.reset_failed_attempts!

      unless user.confirmed?
        flash.now[:alert] = "Please confirm your email first"
        render :new, status: :unauthorized
        return
      end

      session[:user_id] = user.id
      if params[:remember_me] == "1"
        user.remember!
        cookies.permanent.signed[:remember_token] = user.remember_token
        cookies.permanent.signed[:remember_user_id] = user.id
      end

      redirect_to home_path, notice: "Logged in"
    else
      user&.increment_failed_attempts!
      if user&.locked?
        token = user.generate_unlock_token!
        UserMailer.unlock_account(user, token).deliver_later
      end
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unauthorized
    end
  end

  def destroy
    if current_user
      current_user.forget!
    end
    session.delete(:user_id)
    cookies.delete(:remember_token)
    cookies.delete(:remember_user_id)

    redirect_to login_path, notice: "Logged out"
  end
end
