class UsersController < ApplicationController
  before_action :set_user, only: [ :edit, :update, :destroy ]

  def index
    @users = User.order(created_at: :desc)
  end

  def new
    @user = User.new
  end

  def create
    # @user = User.new(user_params)

    if Users::Create.new(user_params).call
      redirect_to edit_user_path(@user), notice: "User created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
     # if @user.update(user_params)
     if Users::Update.new(@user, user_params).call
      redirect_to edit_user_path(@user), notice: "User updated successfully"
     else
      render :edit, status: :unprocessable_entity
     end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: "User deleted successfully"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
