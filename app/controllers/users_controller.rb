class UsersController < ApplicationController
  before_action :set_user, only: [ :edit, :update, :destroy, :update_role ]

  # Authorization
  before_action :authorize_index,  only: :index
  before_action :authorize_create, only: [ :new, :create ]
  before_action :authorize_update, only: [ :edit, :update ]
  before_action :authorize_destroy, only: :destroy
  before_action :authorize_role_update, only: :update_role

  skip_before_action :require_login, only: [ :new, :create ]

  def index
    # authorize!(User, :index)
    @users = User.order(created_at: :desc)
  end

  def new
    # authorize!(User, :create)
    @user = User.new
  end

  def create
    # authorize!(User, :create)
    # @user = User.new(user_params)
    @user = Users::Create.new(user_params).call

    if @user.persisted?
      redirect_to edit_user_path(@user), notice: "User created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # authorize!(User, :update)
  end

  def update
     # authorize!(User, :update)
     # if @user.update(user_params)
     if Users::Update.new(@user, user_params).call
      redirect_to edit_user_path(@user), notice: "User updated successfully"
     else
      render :edit, status: :unprocessable_entity
     end
  end

  def destroy
    # authorize!(User, :destroy)
    @user.destroy
    redirect_to users_path, notice: "User deleted successfully"
  end
  def update_role
    if Users::UpdateRole.new(@user, params[:role]).call
      redirect_to users_path, notice: "Role updated"
    else
      redirect_to users_path, alert: "Invalid role"
    end
  end
  private

  def set_user
    @user = User.find(params[:id])
  end



  def authorize_index
    authorize!(User, :index)
  end

  def authorize_create
    authorize!(User, :create)
  end

  def authorize_update
    authorize!(@user, :update)
  end

  def authorize_destroy
    authorize!(@user, :destroy)
  end
  def authorize_role_update
    authorize!(@user, :update_role)
  end

  def user_params
    permitted = params.require(:user).permit(:name, :email, :password, :password_confirmation).to_h
    if permitted[:password].blank?
      permitted.delete(:password)
      permitted.delete(:password_confirmation)
    end
    permitted
  end
end
