# frozen_string_literal: true

module Memberships
  class UpdateAvatar
    MAX_SIZE = 5.megabytes

    ALLOWED_CONTENT_TYPES = %w[
      image/png
      image/jpeg
      image/jpg
      image/webp
    ].freeze

    class Error < StandardError; end

    def initialize(actor:, membership:, file:)
      @actor = actor
      @membership = membership
      @file = file
    end

    def call
      authorize!
      validate_file!

      # membership.save!
      # membership.reload

      membership.avatar.attach(file)
      membership
    end

    private

    attr_reader :actor, :membership, :file

    def authorize!
      Pundit.authorize(actor, membership, :update_avatar?)
    end

    def validate_file!
      raise Error, "File is required" unless file
      validate_content_type!
      validate_size!
    end

    def validate_content_type!
      return if ALLOWED_CONTENT_TYPES.include?(file.content_type)
      raise Error, "Invalid file type"
    end

    def validate_size!
      return if file.size <= MAX_SIZE
      raise Error, "File size exceeds limit (#{MAX_SIZE / 1.megabyte}MB)"
    end
  end
end
