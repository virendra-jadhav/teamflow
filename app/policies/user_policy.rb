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

  private

  def membership
    @membership ||= user.memberships.find_by(account: current_account)
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
