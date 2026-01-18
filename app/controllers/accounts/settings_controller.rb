module Accounts
  class SettingsController < ApplicationController
    # def show
    #   authorize current_account, :settings?
    # end
    def show
      authorize current_account
    end

    def update
      authorize current_account
      if current_account.update(account_params)
        redirect_to accounts_settings_path, notice: "Account updated successfully"
      else
        render :show, status: :unprocessable_entity
      end
    end
    def destroy
      authorize current_account
      ActiveRecord::Base.transaction do
        current_account.destroy!
        session.delete(:current_account_id)
        # session[:current_account_id]
      end
      redirect_to home_path, notice: "Account deleted."
    rescue ActiveRecord::RecordNotDestroyed => e
      redirect_to accounts_settings_path, alert: e.message
    end
    private
    def account_params
      params.require(:account).permit(:name)
    end
  end
end
