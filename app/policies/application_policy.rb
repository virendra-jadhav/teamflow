class ApplicationPolicy
  attr_reader :user, :record, :account

  # Pundit calls this automatically
  def initialize(pundit_user, record)
    @user    = pundit_user.user
    @account = pundit_user.account
    @record  = record
  end

  # -------------------------
  # SCOPE (optional for later)
  # -------------------------
  class Scope
    attr_reader :user, :scope, :account

    def initialize(pundit_user, scope)
      @user    = pundit_user.user
      @account = pundit_user.account
      @scope   = scope
    end

    def resolve
      scope.none
    end
  end
end



# class ApplicationPolicy
#   attr_reader :user, :record

#   def initialize(user, record)
#     @user   = user     # current_user
#     @record = record   # model or class
#   end

#   class Scope
#     attr_reader :user, :scope

#     def initialize(user, scope)
#       @user  = user
#       @scope = scope
#     end

#     def resolve
#       raise NotImplementedError, "You must define #resolve"
#     end
#   end
# end
