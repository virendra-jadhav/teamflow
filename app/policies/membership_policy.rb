class MembershipPolicy < ApplicationPolicy
  def update?
    admin?
  end
  def destroy?
    admin?
  end
  private
  def admin?
    Membership.exists?(
      user: user,
      account: account,
      role: "admin"
    )
  end
end
