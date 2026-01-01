class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  protect_from_forgery with: :null_session

  before_action :require_login

  helper_method :current_user

  def require_login
    return if current_user
    redirect_to login_path, alert: "Please log in"
  end
  

  private

  def current_user
    return @current_user if defined?(@current_user)

    @current_user = User.find_by(id: session[:user_id])
  end

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
