class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  protect_from_forgery with: :null_session

  helper_method :current_user

  def current_user
    @current_user
  end

  private

  def authorize!(record, action)
    policy = policy_for(record)
    allowed = policy.public_send("#{action}?")

    return if allowed

    head :forbidden
  end

  def policy_for(record)
    klass =
      if record.is_a?(Class)
        record
      else
        record.class
      end

    "#{klass}Policy".constantize.new(current_user, record)
  end
end
