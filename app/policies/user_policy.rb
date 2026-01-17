class UserPolicy < ApplicationPolicy
  def index?
    membership&.admin?
  end

  def create?
    membership&.admin?
  end

  def update?
    membership&.admin? || record == user
  end

  def destroy?
    membership&.admin?
  end

  def update_role?
    membership&.admin?
  end

  class Scope < Scope
    def resolve
      return scope.none unless user && account

      scope.joins(:memberships)
        .where(memberships: { account_id: account.id })
    end
  end

  private

  def membership
    return nil unless user && account
    # user.memberships.find_by(account: current_account)
    @membership ||= user.memberships.find_by(account: account)
  end
end

# class UserPolicy < ApplicationPolicy
#   def index?
#     # user.admin?
#     user.present?
#   end

#   def create?
#     user.admin?
#   end

#   def update?
#     user.admin? || record == user
#   end

#   def destroy?
#     user.admin?
#   end

#   def update_role?
#     user.admin?
#   end

#   # -------------------------
#   # SCOPE
#   # -------------------------
#   class Scope < Scope
#     def resolve
#       if user.admin?
#         scope.all
#       else
#         scope.where(id: user.id)
#       end
#     end
#   end

#   # -------------------------
#   # ❌ OLD POLICY (REFERENCE)
#   # -------------------------
#   # attr_reader :current_user, :record
#   #
#   # def initialize(current_user, record)
#   #   @current_user = current_user
#   #   @record = record
#   # end
# end
