class InvitationPolicy < ApplicationPolicy
  def index?
    membership&.admin?
  end
  def create?
    membership&.admin?
  end
  def resend?
    membership&.admin?
  end
  def revoke?
    membership&.admin?
  end
  private
  def membership
    user.memberships.find_by(account: account)
  end
end
