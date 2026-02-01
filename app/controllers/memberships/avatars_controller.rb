# frozen_string_literal: true

#
module Memberships
  class AvatarsController < ApplicationController
    def update
      membership = current_account.memberships.find(params[:membership_id])

      Memberships::UpdateAvatar.new(
        actor: pundit_user,
        membership: membership,
        file: params.require(:avatar)
      ).call

      redirect_to accounts_settings_path, notice: "Avatar updated successfully"

    rescue Memberships::UpdateAvatar::Error => e
      redirect_back fallback_location: accounts_settings_path, alert: e.message
    end

    def destroy
      membership = current_account.memberships.find(params[:membership_id])

      authorize membership, :remove_avatar?

      membership.avatar.purge

      redirect_to accounts_settings_path, notice: "Avatar removed successfully"
    end
  end
end
