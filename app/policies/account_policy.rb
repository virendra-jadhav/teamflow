class AccountPolicy < ApplicationPolicy
  # def settings?
  #   return false unless user && account
  #   membership&.admin?
  # end
  def show?
    membership&.admin?
  end
  def update?
    membership&.admin?
  end
  def destroy?
    membership&.admin?
  end

  private
  def membership
    @membership ||= user.memberships.find_by(account: record)
  end
end
