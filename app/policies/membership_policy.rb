class MembershipPolicy < ApplicationPolicy
  def update?
    admin?
  end
  def destroy?
    admin? && record.user != user
  end
  def update_role?
     admin?
  end
  def transfer_ownership?
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
