class AccountPolicy < ApplicationPolicy
  # def settings?
  #   return false unless user && account
  #   membership&.admin?
  # end
  # def show?
  #   membership&.admin?
  # end
  # def update?
  #   membership&.admin?
  # end
  # def destroy?
  #   membership&.admin?
  # end

  # private
  # def membership
  #   @membership ||= user.memberships.find_by(account: record)
  # end
  def show?
    admin?
  end
  def update?
    admin?
  end
  def destroy?
    admin? && sole_member?
  end

  private
  def admin?
    Membership.exists?(
      user: user,
      account: account,
      role: "admin"
    )
  end

  def sole_member?
    record.memberships.count == 1
  end
end
