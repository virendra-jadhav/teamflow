class UsersController < ApplicationController
  before_action :set_user, only: [ :edit, :update, :destroy, :update_role ]

  # skip_before_action :require_login, only: [ :new, :create ]
  skip_before_action :require_login, only: %i[new create]

  def index
    # # authorize!(User, :index)
    # @users = User.order(created_at: :desc)
    # authorize User
    # authorize User, policy_class: UserPolicy, account: current_account
    authorize User
    # @users = policy_scope(User)
    @users = current_account.users
  end

  def new
    # # authorize!(User, :create)
    # @user = User.new
    # authorize User
    # authorize User, policy_class: UserPolicy, account: current_account
    authorize User
    @user = User.new
  end

  def create
    # # authorize!(User, :create)
    # # @user = User.new(user_params)
    # @user = Users::Create.new(user_params).call

    # if @user.persisted?
    #   redirect_to edit_user_path(@user), notice: "User created successfully"
    # else
    #   render :new, status: :unprocessable_entity
    # end
    # authorize User
    # authorize User, policy_class: UserPolicy, account: current_account
    authorize User
    @user = Users::Create.new(user_params).call

    if @user.persisted?
      redirect_to edit_user_path(@user), notice: "User created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # authorize!(User, :update)
    # authorize @user
    # authorize @user, policy_class: UserPolicy, account: current_account
    authorize @user
  end

  def update
     #  # authorize!(User, :update)
     #  # if @user.update(user_params)
     #  if Users::Update.new(@user, user_params).call
     #   redirect_to edit_user_path(@user), notice: "User updated successfully"
     #  else
     #   render :edit, status: :unprocessable_entity
     #  end
     #  authorize @user
     #  authorize @user, policy_class: UserPolicy, account: current_account
     authorize @user
    if Users::Update.new(@user, user_params).call
      redirect_to edit_user_path(@user), notice: "User updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # # authorize!(User, :destroy)
    # @user.destroy
    # redirect_to users_path, notice: "User deleted successfully"
    #  authorize @user
    #  authorize @user, policy_class: UserPolicy, account: current_account
    authorize @user
    @user.destroy
    redirect_to users_path, notice: "User deleted successfully"
  end
  def update_role
    # if Users::UpdateRole.new(@user, params[:role]).call
    #   redirect_to users_path, notice: "Role updated"
    # else
    #   redirect_to users_path, alert: "Invalid role"
    # end
    # authorize @user, :update_role?
    # authorize @user, :update_role?, policy_class: UserPolicy, account: current_account
    authorize @user, :update_role?
    if Users::UpdateRole.new(@user, current_account, params[:role]).call
      redirect_to users_path, notice: "Role updated"
    else
      redirect_to users_path, alert: "Invalid role"
    end
  end
  private

  def set_user
    @user = User.find(params[:id])
  end

  def ensure_account_selected
    return if current_account
    redirect_to root_path, alert: "Please create or select account first"
  end


  # def authorize_index
  #   authorize!(User, :index)
  # end

  # def authorize_create
  #   authorize!(User, :create)
  # end

  # def authorize_update
  #   authorize!(@user, :update)
  # end

  # def authorize_destroy
  #   authorize!(@user, :destroy)
  # end
  # def authorize_role_update
  #   authorize!(@user, :update_role)
  # end

  def user_params
    permitted = params.require(:user).permit(:name, :email, :password, :password_confirmation).to_h
    # .reject { |_, v| v.blank? }
    if permitted[:password].blank?
      permitted.delete(:password)
      permitted.delete(:password_confirmation)
    end
    permitted
  end
end
