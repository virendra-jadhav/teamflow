class RegistrationsController < ApplicationController
  skip_before_action :require_login

  def new
    @user = User.new
  end

  def create
    @user = Users::Create.new(user_params).call

    if @user.persisted?
      redirect_to login_path, notice: "Check your email to confirm your account"
    else
      render :new, status: :unprocessable_entity
    end
  end
   private

  def user_params
    params.require(:user)
          .permit(:name, :email, :password, :password_confirmation)
  end
end
