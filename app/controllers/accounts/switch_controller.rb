class Accounts::SwitchController < ApplicationController
  before_action :require_login
  skip_before_action :require_account!, only: [ :create ]

  def create
    if params[:account_id].blank?
      redirect_back fallback_location: root_path,
        alert: "Please select an account"
      return
    end
    account = current_user.accounts.find(params[:account_id])

    session[:current_account_id] = account.id

    redirect_to root_path, notice: "Switched to #{account.name}"
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: "You do not have access to that account."
  end
end
