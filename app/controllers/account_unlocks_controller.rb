class AccountUnlocksController < ApplicationController
  skip_before_action :require_login

  def edit
    user = User.find_by(id: params[:user_id])
    unless user&.valid_unlock_token?(params[:token])
      redirect_to login_path, alert: "Invalid or expired unlock link"
      return
    end
    user.unlock!
    redirect_to login_path, notice: "Account unlocked successfully"
  end
end
