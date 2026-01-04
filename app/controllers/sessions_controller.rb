class SessionsController < ApplicationController
  skip_before_action :require_login, only: [ :new, :create ]
  skip_before_action :verify_authenticity_token

  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
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
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unauthorized
    end
  end

  def destroy
    binding.pry
    if current_user
      current_user.forget!
    end
    session.delete(:user_id)
    cookies.delete(:remember_token)
    cookies.delete(:remember_user_id)

    redirect_to login_path, notice: "Logged out"
  end
end
