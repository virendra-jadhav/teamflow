class UsersController < ApplicationController
  before_action :set_user, only: [ :edit, :update, :destroy ]

  # Authorization
  before_action :authorize_index,  only: :index
  before_action :authorize_create, only: [ :new, :create ]
  before_action :authorize_update, only: [ :edit, :update ]
  before_action :authorize_destroy, only: :destroy

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

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email)
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
end
