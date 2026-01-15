class AccountsController < ApplicationController
  def new
    @account = Account.new
  end
  def create
    result = Account::Create.new(
      user: current_user,
      account_params: account_params
    ).call

    if result.persisted?
      session[:current_account_id] = result.id
      redirect_to root_path, notice: "Account created successfully!!"
    else
      @account = result
      render :new, status: :unprocessable_entity
    end
  end
  private
  def account_params
    params.require(:account).permit(:name)
  end
end
