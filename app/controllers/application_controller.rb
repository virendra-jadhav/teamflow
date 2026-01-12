class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  # protect_from_forgery with: :null_session
  protect_from_forgery with: :exception


  before_action :require_login

  helper_method :current_user, :current_account, :current_membership

  def require_login
    return if current_user
    redirect_to login_path, alert: "Please log in"
  end


  private

  def current_user
    # return @current_user if defined?(@current_user)

    # @current_user = User.find_by(id: session[:user_id])

    # @current_user ||= User.find_by(id: session[:user_id])
    #
    return @current_user if defined?(@current_user)

    # @current_user = User.find_by(id: session[:user_id])
    # session.delete(:user_id) if @current_user.nil?
    # @current_user

    if session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
    elsif cookies.signed[:remember_user_id]
      user = User.find_by(id: cookies.signed[:remember_user_id])
      if user&.authenticate_with_remember_token?(cookies.signed[:remember_token])
        session[:user_id] = user.id
        @current_user = user
      end
    end
  end

  # -------------------------
  # PUNDIT
  # -------------------------
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def current_account
    return @current_account if defined?(@current_account)

    return nil unless session[:current_account_id]
    return nil unless current_user

    @current_account = current_user.accounts.find_by(id: session[:current_account_id])
  end

  def user_not_authorized
    respond_to do |format|
      format.html { render file: Rails.root.join("public/403.html"), status: :forbidden }
      format.json { head :forbidden }
    end
  end

  # custom authorization before pundit
  # def authorize!(record, action)
  #   policy = policy_for(record)
  #   allowed = policy.public_send("#{action}?")
  #   return if allowed

  #   # head :forbidden
  #   # respond_to do |format|
  #   #   format.html { redirect_to users_path, alert: "Not authorized" }
  #   #   format.json { head :forbidden }
  #   # end
  #   respond_to do |format|
  #     format.html { render file: Rails.root.join("public/403.html"), status: :forbidden }
  #     format.json { head :forbidden }
  #   end
  # end

  # def policy_for(record)
  #   klass =
  #     if record.is_a?(Class)
  #       record
  #     else
  #       record.class
  #     end
  #   "#{klass}Policy".constantize.new(current_user, record)
  # end
end
