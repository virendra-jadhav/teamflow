class PasswordResetsController < ApplicationController
  skip_before_action :require_login

  def new
  end
  def create
    user = User.find_by(email: params[:email])
    if user
      token = user.generate_password_reset!
      Rails.logger.info "RESET TOKEN : #{token}"
    end
    redirect_to login_path, notice: "If your email exists, you will receive reset instructions"
  end
  def edit
    @user = User.find_by(reset_password_token: params[:token])
    if @user.nil? || @user.reset_token_expired?
      redirect_to login_path, alert: "Reset link expired."
    end
  end
  def update
    @user = User.find_by(reset_password_token: params[:token])
    if @user.nil? || @user.reset_token_expired?
      redirect_to login_path, alert: "Reset link expired."
      return
    end
    if @user.update(password_params)
      @user.clear_password_reset!
      redirect_to login_path, notice: "Password updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end
  private
  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
