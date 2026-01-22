class InvitationsController < ApplicationController
  skip_before_action :require_login
  before_action :set_invitation, only: [ :accept, :confirm, :resend, :revoke ]
  skip_before_action :require_account!, only: [ :accept, :confirm ]


  def index
    authorize Invitation
    @invitations = current_account.invitations.order(created_at: :desc)
  end

  def create
    result = Invitations::Create.new(
      account: current_account,
      invited_by: current_user,
      email: params[:email],
      role: params[:role]
    ).call
    if result.persisted?
      redirect_to invitations_path, notice: "Invitation sent to #{result.email}"
    else
      redirect_to invitations_path, alert: result.errors.full_messages.to_sentence
    end
  end

  def accept
    unless @invitation.valid_for_acceptance?(params[:token])
      render plain: "Invalid or expired invitation", status: :unprocessable_entity
      return
    end
    unless current_user
      session[:pending_invitation_id] = @invitation.id
      session[:pending_invitation_token] = params[:token]
      puts "id : #{session[:pending_invitation_id]}"
      puts "login"
      redirect_to login_path, alert: "Please log in to accept invitation"
    end
  end

  def confirm
    unless @invitation.valid_for_acceptance?(params[:token])
      redirect_to root_path, alert: "Invalid or expired invitation"
      return
    end
    result = Invitations::Accept.new(
      invitation: @invitation,
      user: current_user
    ).call

    if result.success?
      session.delete(:pending_invitation_id)
      session.delete(:pending_invitation_token)
      redirect_to root_path, notice: "You joined #{@invitation.account.name}"
    else
      redirect_to root_path, alert: result.error
    end
  end

  def resend
    authorize @invitation
    result = Invitations::Resend.new(
      invitation: @invitation,
      resent_by: current_user
    ).call
    if result.success?
      redirect_to invitations_path, notice: "Invatations resent"
    else
      redirect_to invitations_path, alert: result.error
    end
  end

  def revoke
    authorize @invitation
    @invitation.destroy
    redirect_to invitations_path, notice: "Invatations revoked"
  end

  private
  def set_invitation
    @invitation = Invitation.find(params[:id])
  end
end
