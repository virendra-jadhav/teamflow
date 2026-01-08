class Accounts::SwitchController < ApplicationController
  before_action :require_login

  def create 
    account = current_user.accounts.find(params[:account_id])

    session[:current_account_id] = account.id 

    redirect_to root_path, notice: "Switched to #{account.name}"
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: "You do not have access to that account."
  end
end