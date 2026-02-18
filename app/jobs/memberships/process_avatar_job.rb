# frozen_string_literal: true


module Memberships
  class ProcessAvatarJob < ApplicationJob
    # queue_as :default
    queue_as :images
    retry_on StandardError, wait: :exponentially_longer, attempts: 5

    def perform(membership_id)
      membership = Membership.find(membership_id)

      return unless membership&.avatar&.attached?

      # force processing & cache the variant
      sleep 1
      raise "Error"
      membership.avatar_thumb.processed
    end
  end
end
