class MembershipsController < ApplicationController
  def update_role
    membership = Membership.find(params[:id])

    authorize membership, :update_role?

    success = Memberships::UpdateRole.new(
        membership: membership,
        role: params[:role],
        actor: current_user
      ).call

    if success
      redirect_to accounts_settings_path, notice: "Role updated successfully!"
    else
      redirect_to accounts_settings_path, alert: "Cannot update role"
    end
  end

  def destroy
    membership = Membership.find(params[:id])

    authorize membership

    success = Memberships::Remove.new(
      membership: membership,
      actor: current_user
    ).call

    if success
      redirect_to accounts_settings_path, notice: "Member removed successfully"
    else
      redirect_to accounts_settings_path, alert: "Cannot remove member"
    end
  end

  def transfer_ownership
    membership = Membership.find(params[:id])
    authorize membership, :transfer_ownership?

    success = Memberships::TransferOwnership.new(
      account: membership.account,
      from: current_user,
      to: membership.user
    ).call

    if success
      redirect_to accounts_settings_path, notice: "Ownership transferred successfully"
    else
      redirect_to accounts_settings_path, alert: "Unable to transfer ownership"
    end
  end
end
