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

  # Avatar policy
  def update_avatar?
    admin? || own_membership?
  end
  def remove_avatar?
    update_avatar?
  end
  def view_avatar?
    true # scoped by membership visibility
  end


  private
  def admin?
    Membership.exists?(
      user: user,
      account: account,
      role: "admin"
    )
  end
  def own_membership?
    record.user_id == user.id
  end
end
