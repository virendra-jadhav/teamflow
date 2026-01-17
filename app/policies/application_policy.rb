class ApplicationPolicy
  attr_reader :user, :record, :account

  def initialize(context, record)
    @user   = context.user     # current_user
    @record = record   # model or class
    @account = context.account
  end

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
