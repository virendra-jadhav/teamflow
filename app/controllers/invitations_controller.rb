class InvitationsController < ApplicationController
  skip_before_action :require_login, only: [ :accept ]
  before_action :set_invitation

  def accept
    unless @invitation.valid_for_acceptance?(params[:token])
      render plain: "Invalid or expired invitation", status: :unprocessable_entity
      return
    end
    unless current_user
      session[:pending_invitation_id] = @invitation.id
      redirect_to login_path, alert: "Please log in to accept invitation"
      nil
    end
  end

  def confirm
    result = Invitation::Accept.new(
      invitation: @invitation,
      user: current_user
    ).call
    if result.success?
      redirect_to root_path, notice: "You joined #{@invitation.account.name}"
    else
      redirect_to root_path, alert: result.error
    end
  end

  private
  def set_invitation
    @invitation = Invitation.find(params[:id])
  end
end
